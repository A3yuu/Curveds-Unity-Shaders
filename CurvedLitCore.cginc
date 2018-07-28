#ifndef CURVED_LIT_CORE_INCLUDED

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
uniform sampler2D _ColorMask; uniform float4 _ColorMask_ST;
uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
uniform sampler2D _RimLightTex; uniform float4 _RimLightTex_ST;
uniform sampler2D _HighLightTex; uniform float4 _HighLightTex_ST;

uniform float4 _Color;
uniform float _Shadow;
uniform float _ShadowMag;
uniform float _ShadowOffset;
uniform float _ReflectionPower;
uniform float _Reflection;
uniform float _Cutoff;
uniform float4 _EmissionColor;
uniform float _RimPower;
uniform float4 _RimColor;
uniform float _HighLightPower;
uniform float4 _HighLightColor;

#ifdef _FURNUM
uniform sampler2D _FurTex;
uniform float4 _FurGravity;
uniform float _FurLength;
uniform float _FurFact;
#endif

static const half3 grayscale_vector = half3(0.298912, 0.586611, 0.114478);

struct VertexOutput
{
	float4 pos : SV_POSITION;
	float2 uv0 : TEXCOORD0;
	float2 uv1 : TEXCOORD1;
	float4 posWorld : TEXCOORD2;
	float3 normalDir : TEXCOORD3;
	float4 col : COLOR;
	SHADOW_COORDS(6)
	UNITY_FOG_COORDS(7)
};

VertexOutput vert(appdata_full v) {
	VertexOutput o;
	o.uv0 = v.texcoord;
	o.normalDir = UnityObjectToWorldNormal(v.normal);
	o.posWorld = mul(unity_ObjectToWorld, v.vertex);
	#ifdef _FURNUM
	o.uv1 = v.texcoord * _FurFact;
	float4 vertex  = float4(v.vertex.xyz + normalize(normalize(v.normal) + _FURNUM * (1 - _FURNUM * 0.5) * _FurGravity.xyz) * _FURNUM * _FurLength, 1.0);
	o.pos = UnityObjectToClipPos(vertex);
	#else
	o.uv1 = v.texcoord;
	o.pos = UnityObjectToClipPos(v.vertex);
	#endif
	o.col = v.color;
	TRANSFER_SHADOW(o);
	UNITY_TRANSFER_FOG(o, o.pos);
	return o;
}

float4 frag(VertexOutput i) : COLOR
{
	//Fur
	#ifdef _FURNUM
	if (tex2D(_FurTex, i.uv1).r < _FURNUM) {
		discard;
	}
	#endif

	//Bace
	float3 objPos = i.posWorld.xyz;
	float4 baseColor = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
	float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - objPos);
	float3 normalDirection = normalize(i.normalDir);
	float3 lightDirection = lerp(float3(0.0, 1.0, 0.0), lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - objPos, _WorldSpaceLightPos0.w), any(_WorldSpaceLightPos0.xyz));

	//Normal
	#if defined(_USE_NORMALMAP)
	float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, normalDirection);
	float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
	normalDirection = normalize(mul(_NormalMap_var.rgb, tangentTransform));
	#endif

	//Mask
	float4 _ColorMask_var = 0;
	#if defined(_USE_COLORMASK)
	_ColorMask_var = tex2D(_ColorMask,TRANSFORM_TEX(i.uv0, _ColorMask));
	#endif
	baseColor = lerp((baseColor.rgba*_Color.rgba),baseColor.rgba,_ColorMask_var.r) * float4(i.col.rgb, 1);

	//Cutoff
	#if defined(_ALPHATEST_ON)
	clip (baseColor.a - _Cutoff);
	#endif

	//Emission
	float3 emissive = 0;
	#if defined(_USE_EMISSION)
	float4 _EmissionMap_var = tex2D(_EmissionMap,TRANSFORM_TEX(i.uv0, _EmissionMap));
	emissive = _EmissionMap_var.rgb * _EmissionColor.rgb;
	#endif

	//Lightmap
	float3 lightmap = 1;
	#ifdef LIGHTMAP_ON
	lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv0 * unity_LightmapST.xy + unity_LightmapST.zw));
	#endif

	//HighLight
	float3 highLighting = 0;
	#ifdef _USE_HIGHLIGHT
	float4 _HighLightTex_var = tex2D(_HighLightTex,TRANSFORM_TEX(i.uv0, _HighLightTex));
	float3 highLightDirection = normalize(viewDirection + lightDirection);
	float highLight = pow(dot(normalDirection, highLightDirection)*0.5+0.5, pow(2, _HighLightPower));
	highLighting = _HighLightTex_var * highLight * _HighLightColor.rgb;
	#endif

	//Rim
	float3 rimLighting = 0;
	#if defined(_USE_RIM)
	float4 _RimLightTex_var = tex2D(_RimLightTex,TRANSFORM_TEX(i.uv0, _RimLightTex));
	float rimLight = pow(1.0 - abs(dot(normalDirection, viewDirection)), _RimPower);
	rimLighting = _RimLightTex_var * rimLight * _RimColor.rgb;
	#endif

	//Reflection
	float3 reflectionMap = 0;
	#ifdef _USE_REFLECTION
	reflectionMap = DecodeHDR(UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, viewDirection, _ReflectionPower), unity_SpecCube0_HDR)* _Reflection;
	#endif

	//Lighting
	float3 lightColor = _LightColor0.rgb;
	UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);
	#ifdef _PASS_FORWARDADD
	float lightContribution = dot(lightDirection, normalDirection)*attenuation;
	float3 directContribution = saturate((1.0 - _Shadow) * attenuation + saturate(lightContribution*2.0-0.5));
	float3 lighting = lerp(0, lightColor, directContribution);
	#else
	//DirectLighting
	float remappedLight = dot(lightDirection, normalDirection)*attenuation;
	//IndirectLighting
	half3 bottomIndirectLighting = 0;
	half3 topIndirectLighting = 0;
	#ifdef _USE_INDIRECTLIGHTING
	float grayscalelightcolor = dot(lightColor, grayscale_vector);
	bottomIndirectLighting = ShadeSH9(half4(0.0, -1.0, 0.0, 1.0));
	topIndirectLighting = ShadeSH9(half4(0.0, 1.0, 0.0, 1.0));
	float grayscaleBottomIndirectLighting = dot(bottomIndirectLighting, grayscale_vector);
	float grayscaleTopIndirectLighting = dot(topIndirectLighting, grayscale_vector);
	float lightDifference = grayscalelightcolor + grayscaleTopIndirectLighting - grayscaleBottomIndirectLighting;
	remappedLight = (remappedLight * grayscalelightcolor + dot(ShadeSH9(half4(normalDirection,1)), grayscale_vector) - grayscaleBottomIndirectLighting) / lightDifference;
	#endif
	//Lighting
	float directContribution = saturate((1.0 - _Shadow) + saturate(remappedLight*_ShadowMag+_ShadowOffset));
	float3 indirectLighting = saturate(bottomIndirectLighting + reflectionMap);
	float3 directLighting = saturate(topIndirectLighting + reflectionMap + lightColor);
	float3 lighting = lerp(indirectLighting, directLighting, directContribution);
	#endif

	//Fin
	float3 finalColor = emissive + (baseColor + rimLighting + highLighting) * lighting;
	fixed4 finalRGBA = fixed4(finalColor * lightmap, baseColor.a);
	UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
	
	return finalRGBA;
}

#endif