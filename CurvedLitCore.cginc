#ifndef CURVED_LIT_CORE_INCLUDED

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
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
uniform float _HighLightMag;
uniform float4 _HighLightColor;

#if defined(_USE_HAIRLIGHT)
uniform float4 _HairLightColor;
uniform sampler2D _HairLightTex; uniform float4 _HairLightTex_ST;
#endif

#if defined(_USE_HAIRHIGHT) || defined(_USE_GEOM_HAIR)
uniform sampler2D _HairHightTex; uniform float4 _HairHightTex_ST;
uniform sampler2D _HairHightTex2; uniform float4 _HairHightTex2_ST;
uniform float _HairHightNum;
uniform float _HairCut;
uniform float _HairWind;
#endif

#if defined(_FURNUM) || defined(_USE_GEOM_FUR)
uniform sampler2D _FurMap;
#if defined(_USE_FURTEX)
uniform sampler2D _FurTex; uniform float4 _FurTex_ST;
#endif
uniform float4 _FurGravity;
uniform float _FurLength;
uniform float _FurFact;
#endif

#if defined(_USE_OUTLINE)
uniform float _OutlineWidth;
uniform float4 _OutlineColor;
#endif

#if defined(_USE_ADDITIONAL)
uniform sampler2D _AdditionalTex; uniform float4 _AdditionalTex_ST;
uniform sampler2D _AdditionalMask; uniform float4 _AdditionalMask_ST;
#endif
#if defined(_USE_ADDITIONAL2)
uniform sampler2D _AdditionalTex; uniform float4 _AdditionalTex_ST;
uniform float _AdditionalNum;
#endif
#if defined(_USE_ADDITIONAL4)
uniform sampler2D _AdditionalMask; uniform float4 _AdditionalMask_ST;
uniform sampler2D _AdditionalLace; uniform float4 _AdditionalLace_ST;
uniform float4 _AdditionalColor;
uniform float _AdditionalLaceAdd1;
uniform float _AdditionalLaceAdd2;
uniform float _AdditionalLaceNum;
#endif
#if defined(_USE_ADDITIONALSKIRT)
uniform sampler2D _AdditionalLace; uniform float4 _AdditionalLace_ST;
uniform float _AdditionalLaceNum;
#endif
#if defined(_USE_ADDITIONALADD)
uniform sampler2D _AdditionalAdd; uniform float4 _AdditionalAdd_ST;
uniform float _AdditionalAddNum;
#endif
#if defined(_USE_ADDITIONALFRILL)
uniform sampler2D _AdditionalFrill; uniform float4 _AdditionalFrill_ST;
#endif


static const half3 grayscale_vector = half3(0.298912, 0.586611, 0.114478);

struct VertexOutput
{
	float4 pos : SV_POSITION;
	float2 uv0 : TEXCOORD0;
	#if defined(_USE_ADDITIONAL) || defined(_FURNUM) || defined(_USE_GEOM_FUR)
	float2 uv1 : TEXCOORD1;
	#endif
	float4 vertex : TEXCOORD2;
	float4 posWorld : TEXCOORD3;
	float3 normalDir : NORMAL;
	#if defined(_USE_NORMALMAP)
	float3 tangentDir : TANGENT;
	float3 bitangentDir : TEXCOORD4;
	#endif
	#if defined(_USE_TESSELLATION) || defined(_USE_OUTLINE) || defined(_USE_GEOM_FUR) || defined(_USE_GEOM_HAIR)
	float3 normalDirOrg : TEXCOORD5;
	#endif
	#if defined(_USE_GEOM_HAIR) 
	float3 tangentDirOrg : TEXCOORD6;
	#endif
	//float3 bitangentDirOrg : TEXCOORD7;
	float4 col : COLOR;
	SHADOW_COORDS(8)
	UNITY_FOG_COORDS(9)
	float3 viewDir : TEXCOORD10;
	float3 lightDir : TEXCOORD11;
	#if defined(_USE_HAIRLIGHT) || defined(_USE_HIGHLIGHT)
	float3 reflectionDir : TEXCOORD12;
	#endif
	#if defined(_USE_HAIRLIGHT)
	float hairLightDirectionRate : TEXCOORD13;
	#endif
	#if defined(_USE_GEOM_FUR) || defined(_USE_GEOM_HAIR) 
	float furNum : TEXCOORD14;
	#endif
};

VertexOutput vert(appdata_full v) {
	VertexOutput o;
	//テクスチャ
	o.uv0 = v.texcoord;
	#if defined(_USE_ADDITIONAL)
	o.uv1 = float2(v.texcoord.x,v.texcoord.y - _Time.x*0.5);
	#endif
	#if defined(_FURNUM) || defined(_USE_GEOM_FUR)
	o.uv1 = v.texcoord * _FurFact;
	#endif
	//法線
	o.normalDir = UnityObjectToWorldNormal(v.normal);
	#if defined(_USE_NORMALMAP)
	o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
	o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
	#endif
	#if defined(_USE_TESSELLATION) || defined(_USE_OUTLINE) || defined(_USE_GEOM_FUR) || defined(_USE_GEOM_HAIR)
	o.normalDirOrg = normalize(v.normal);
	#endif
	#if defined(_USE_GEOM_HAIR)
	o.tangentDirOrg = normalize(v.tangent);
	#endif
	//頂点
	o.vertex = v.vertex;
	#if defined(_FURNUM)
	o.vertex = float4(v.vertex.xyz + normalize(normalize(v.normal) + _FURNUM * (1 - _FURNUM * 0.5) * _FurGravity.xyz) * _FURNUM * _FurLength, 1.0);
	#elif defined (_USE_HAIRHIGHT)
	float hairHight = tex2Dlod(_HairHightTex, v.texcoord).r * _USE_HAIRHIGHT * _HairHightNum;
	float3 hairNormalAdder = sin(_Time.x*2) * normalize(v.tangent.xyz) + cos(_Time.x*2) * normalize(cross(v.normal.xyz, v.tangent.xyz));
	o.vertex = float4(v.vertex.xyz + (normalize(v.normal) + hairNormalAdder * _HairWind) * hairHight, 1.0);
	#elif defined (_USE_ADDITIONAL4)
	o.vertex = float4(v.vertex.xyz - normalize(v.normal) * (_USE_ADDITIONAL4+_AdditionalLaceAdd1) * (tex2Dlod(_AdditionalMask, v.texcoord).r+_AdditionalLaceAdd2) * _AdditionalLaceNum, 1.0);
	#elif defined (_USE_ADDITIONALADD)
	o.vertex = float4(v.vertex.xyz - normalize(v.normal) * _AdditionalAddNum * (1-v.texcoord.y)*(1-v.texcoord.y), 1.0);
	#elif defined (_USE_ADDITIONALSKIRT)
	o.vertex = float4(v.vertex.xyz - normalize(v.normal) * _AdditionalLaceNum * (1-v.texcoord.y)*(1-v.texcoord.y), 1.0);
	#endif
	//計算
	o.pos = UnityObjectToClipPos(o.vertex);
	o.posWorld = mul(unity_ObjectToWorld, o.vertex);
	//色
	o.col = _Color * v.color;
	#if defined(_USE_ADDITIONAL4)
	o.col = _AdditionalColor * v.color
	#endif
	//各種角度
	o.viewDir = normalize(_WorldSpaceCameraPos.xyz - o.posWorld.xyz);
	o.lightDir = normalize(lerp(float3(0.0, 1.0, 0.0), lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - o.posWorld.xyz, _WorldSpaceLightPos0.w), any(_WorldSpaceLightPos0.xyz)));
	#if defined(_USE_HAIRLIGHT) || defined(_USE_HIGHLIGHT)
	o.reflectionDir = normalize(o.viewDir + o.lightDir);
	#endif
	#if defined(_USE_HAIRLIGHT)
	o.hairLightDirectionRate = dot(o.reflectionDir, o.lightDir);
	#endif
	#if defined(_USE_GEOM_FUR) || defined(_USE_GEOM_HAIR) 
	o.furNum = 0;
	#endif
	TRANSFER_SHADOW(o);
	UNITY_TRANSFER_FOG(o, o.pos);
	return o;
}

float4 frag(VertexOutput i) : COLOR
{
	//Fur
	#if defined(_FURNUM)
	clip(tex2D(_FurMap, i.uv1).r - _FURNUM);
	#endif
	//GeomFur
	#if defined(_USE_GEOM_FUR)
	clip(tex2D(_FurMap, i.uv1).r - i.furNum);
	#endif
	
	//HairHight
	#if defined(_USE_HAIRHIGHT)
	clip(tex2D(_HairHightTex2, i.uv0).r - max(_USE_HAIRHIGHT, _HairCut));
	#endif
	#if defined(_USE_GEOM_HAIR)
	clip(tex2D(_HairHightTex2, i.uv0).r - max(i.furNum, _HairCut));
	#endif

	//Bace
	float3 objPos = i.posWorld.xyz;
	float4 baseColor = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex))*i.col;
	float3 viewDirection = i.viewDir;
	float3 normalDirection = normalize(i.normalDir);
	float3 lightDirection = i.lightDir;
	float3 lightColor = _LightColor0.rgb;
	
	//Additional3
	#if defined(_USE_ADDITIONAL3)
	#if defined(_FURNUM)
	clip(tex2D(_FurMap, i.uv1).r + _FURNUM);
	#endif
	baseColor = i.col;
	#endif
	
	//Additional4
	#if defined(_USE_ADDITIONAL4)
	clip(0.5 - tex2D(_AdditionalLace,TRANSFORM_TEX(i.uv0, _AdditionalLace)).r);
	#endif
	
	//AdditionalSkirt
	#if defined(_USE_ADDITIONALSKIRT)
	baseColor = tex2D(_AdditionalLace,TRANSFORM_TEX(i.uv0, _AdditionalLace))*i.col;
	clip (max(baseColor.a-fmod(i.uv0.x,0.0005)*2000,baseColor.a-fmod(i.uv0.y,0.0005)*2000)-0.001);
	#endif
	#if defined(_USE_ADDITIONALFRILL)
	baseColor = i.col;
	clip(tex2D(_AdditionalFrill,TRANSFORM_TEX(i.uv0, _AdditionalFrill)).a - _Cutoff);
	#endif
	#if defined(_USE_ADDITIONALADD)
	baseColor = tex2D(_AdditionalAdd,TRANSFORM_TEX(i.uv0, _AdditionalAdd))*i.col;
	#endif

	#if defined(_USE_FURTEX)
	float4 furColor = tex2D(_FurTex,TRANSFORM_TEX(i.uv0, _FurTex));
	#if defined(_FURNUM)
	baseColor = baseColor * (1-_FURNUM) + furColor * _FURNUM;
	#endif
	#if defined(_USE_GEOM_FUR)
	baseColor = baseColor * (1-i.furNum) + furColor * i.furNum;
	#endif
	#endif

	//Normal
	#if defined(_USE_NORMALMAP)
	float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, normalDirection);
	float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
	normalDirection = normalize(mul(_NormalMap_var.rgb, tangentTransform));
	#endif

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
	#if defined(LIGHTMAP_ON)
	lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv0 * unity_LightmapST.xy + unity_LightmapST.zw));
	#endif

	//HighLight
	float3 highLighting = 0;
	#if defined(_USE_HIGHLIGHT)
	float4 _HighLightTex_var = tex2D(_HighLightTex,TRANSFORM_TEX(i.uv0, _HighLightTex));
	float highLight = min(pow((dot(normalDirection, i.reflectionDir)+1)*_HighLightMag, pow(2, _HighLightPower)),1);
	highLighting = _HighLightTex_var.rgb * highLight * _HighLightColor.rgb * lightColor;
	#endif
	
	float3 hairLighting = 0;
	#if defined(_USE_HAIRLIGHT)
	float normalDirectionRate = dot(normalDirection, lightDirection);
	float hairY = saturate((normalDirectionRate-i.hairLightDirectionRate)*0.5+0.5);
	float4 _HairLightTex_var = tex2D(_HairLightTex,TRANSFORM_TEX(float2(0, hairY), _HairLightTex));
	hairLighting = _HairLightTex_var.rgb * _HairLightColor.rgb;
	#endif

	//Rim
	float3 rimLighting = 0;
	#if defined(_USE_RIM)
	float4 _RimLightTex_var = tex2D(_RimLightTex,TRANSFORM_TEX(i.uv0, _RimLightTex));
	float rimLight = pow(1.0 - abs(dot(normalDirection, viewDirection)), _RimPower);
	rimLighting = _RimLightTex_var.rgb * rimLight * _RimColor.rgb;
	#endif

	//Reflection
	float3 reflectionMap = 0;
	#if defined(_USE_REFLECTION)
	reflectionMap = DecodeHDR(UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, viewDirection, _ReflectionPower), unity_SpecCube0_HDR)* _Reflection;
	#endif

	//Lighting
	UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);
	#if defined(_PASS_FORWARDADD)
	float lightContribution = dot(lightDirection, normalDirection)*attenuation;
	float3 directContribution = saturate((1.0 - _Shadow) * attenuation + saturate(lightContribution*2.0-0.5));
	float3 lighting = lerp(0, lightColor, directContribution);
	#else
	//DirectLighting
	float remappedLight = dot(lightDirection, normalDirection)*attenuation;
	//IndirectLighting
	half3 bottomIndirectLighting = 0;
	half3 topIndirectLighting = 0;
	#if defined(_USE_INDIRECTLIGHTING)
	float grayscalelightcolor = dot(lightColor, grayscale_vector);
	bottomIndirectLighting = ShadeSH9(half4(0.0, -1.0, 0.0, 1.0));
	topIndirectLighting = ShadeSH9(half4(0.0, 1.0, 0.0, 1.0));
	//bottomIndirectLighting = ShadeSH9(float4(lightDirection,1));
	//topIndirectLighting = ShadeSH9(float4(-lightDirection,1));
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

	//Additional
	#if defined(_USE_ADDITIONAL)
	float3 _AdditionalTex_var = tex2D(_AdditionalTex,TRANSFORM_TEX(i.uv1, _AdditionalTex));
	float _AdditionalMask_var = tex2D(_AdditionalMask,TRANSFORM_TEX(i.uv0, _AdditionalMask));
	float3 additional = _AdditionalTex_var * _AdditionalMask_var;
	//if(additional < 0.1)additional=0;
	if(dot(additional, grayscale_vector) > dot(baseColor.xyz, grayscale_vector))baseColor.xyz = additional;
	#endif
	
	//Additional2
	#if defined(_USE_ADDITIONAL2)
	clip(pow(_AdditionalNum,2) - tex2D(_AdditionalTex, i.uv0).r);
	#endif

	//Fin
	float3 finalColor = emissive + (baseColor + rimLighting + highLighting + hairLighting) * lighting;
	fixed4 finalRGBA = fixed4(finalColor * lightmap, baseColor.a);

	UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
	return finalRGBA;
}

//Fur
#if defined(_USE_GEOM_FUR)
[maxvertexcount(_USE_GEOM_FUR * 3)]
void geom(triangle VertexOutput i[3], inout TriangleStream<VertexOutput> tristream)
{
	for (int j = 0; j < _USE_GEOM_FUR; j++)
	{
		for (int k = 0; k < 3; k++)
		{
			VertexOutput o = i[k];
			o.furNum = 1.0*j/_USE_GEOM_FUR;
			o.vertex += float4(normalize(o.normalDirOrg + o.furNum * (1 - o.furNum * 0.5) * _FurGravity.xyz) * o.furNum * _FurLength, 0);
			o.pos = UnityObjectToClipPos(o.vertex);
			o.posWorld = mul(unity_ObjectToWorld, o.vertex);
			tristream.Append(o);
		}
		tristream.RestartStrip();
	}
}
#endif
//Hair
#if defined(_USE_GEOM_HAIR)
[maxvertexcount(_USE_GEOM_HAIR * 3)]
void geom(triangle VertexOutput i[3], inout TriangleStream<VertexOutput> tristream)
{
	for (int j = 0; j < _USE_GEOM_HAIR; j++)
	{
		for (int k = 0; k < 3; k++)
		{
			VertexOutput o = i[k];
			o.furNum = j/(_USE_GEOM_HAIR-1.0);
			float hairHight = tex2Dlod(_HairHightTex, float4(o.uv0,0,0)).r * o.furNum * _HairHightNum;
			float3 hairNormalAdder = sin(_Time.x*2) * normalize(o.tangentDirOrg.xyz) + cos(_Time.x*2) * normalize(cross(o.normalDirOrg.xyz, o.tangentDirOrg.xyz));
			o.vertex += float4((o.normalDirOrg + hairNormalAdder * _HairWind) * hairHight, 1.0);
			o.pos = UnityObjectToClipPos(o.vertex);
			o.posWorld = mul(unity_ObjectToWorld, o.vertex);
			tristream.Append(o);
		}
		tristream.RestartStrip();
	}
}
#endif
//OutLine
#if defined(_USE_OUTLINE)
[maxvertexcount(6)]
void geom(triangle VertexOutput i[3], inout TriangleStream<VertexOutput> tristream)
{
	for (int j = 2; j >= 0; j--)
	{
		VertexOutput o = i[j];;
		o = i[j];
		o.vertex += float4(i[j].normalDirOrg * _OutlineWidth,0);
		o.pos = UnityObjectToClipPos(o.vertex);
		o.posWorld = mul(unity_ObjectToWorld, o.vertex);
		o.col = _OutlineColor;
		tristream.Append(o);
	}
	tristream.RestartStrip();
	for (int j = 0; j < 3; j++)
	{
		tristream.Append(i[j]);
	}
	tristream.RestartStrip();
}
#endif
//Tessellation
#if defined(_USE_TESSELLATION)
#if defined(_TESSELLATION_QUAD)
#define PATCH_SIZE 4
#else
#define PATCH_SIZE 3
#endif
#include "Tessellation.cginc"
uniform float _TessStrong;
uniform float _TessDistMin;
uniform float _TessDistMax;
uniform float _TessFactor;
#if defined(_USE_TESS_MAP)
uniform sampler2D _TessHightMap; uniform float4 _TessHightMap_ST;
uniform float _TessHightRate;
uniform float _TessHightFact;
#endif
#if defined(_TESSELLATION_QUAD)
struct TessellationFactor {
	float tessFactor[PATCH_SIZE] : SV_TessFactor;
	float insideTessFactor[2] : SV_InsideTessFactor;
};
TessellationFactor hullConst(InputPatch<VertexOutput, PATCH_SIZE> i) {
	TessellationFactor o;
	o.tessFactor[0] = o.tessFactor[1] = o.tessFactor[2] = o.tessFactor[3] = _TessFactor;
	o.insideTessFactor[0] = o.insideTessFactor[1] = _TessFactor;
	return o;
}
[domain("quad")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(PATCH_SIZE)]
[patchconstantfunc("hullConst")]
VertexOutput hull(InputPatch<VertexOutput, PATCH_SIZE> i, uint id:SV_OutputControlPointID) {
	return i[id];
}
[domain("quad")]
VertexOutput domain(TessellationFactor hullConst, const OutputPatch<VertexOutput, PATCH_SIZE> i, float2 weight:SV_DomainLocation) {
	VertexOutput o = i[0];
	o.uv0 = lerp(lerp(i[0].uv0, i[1].uv0, weight.x), lerp(i[3].uv0, i[2].uv0, weight.x),weight.y);
	#if defined(_USE_ADDITIONAL) || defined(_FURNUM) || defined(_USE_GEOM_FUR)
	o.uv1 = lerp(lerp(i[0].uv1, i[1].uv1, weight.x), lerp(i[3].uv1, i[2].uv1, weight.x),weight.y);
	#endif
	o.normalDir = lerp(lerp(i[0].normalDir, i[1].normalDir, weight.x), lerp(i[3].normalDir, i[2].normalDir, weight.x),weight.y);
	#if defined(_USE_NORMALMAP)
	o.tangentDir = lerp(lerp(i[0].tangentDir, i[1].tangentDir, weight.x), lerp(i[3].tangentDir, i[2].tangentDir, weight.x),weight.y);
	o.bitangentDir = lerp(lerp(i[0].bitangentDir, i[1].bitangentDir, weight.x), lerp(i[3].bitangentDir, i[2].bitangentDir, weight.x),weight.y);
	#endif
	o.col = lerp(lerp(i[0].col, i[1].col, weight.x), lerp(i[3].col, i[2].col, weight.x),weight.y);
	o.viewDir = lerp(lerp(i[0].viewDir, i[1].viewDir, weight.x), lerp(i[3].viewDir, i[2].viewDir, weight.x),weight.y);
	o.lightDir = lerp(lerp(i[0].lightDir, i[1].lightDir, weight.x), lerp(i[3].lightDir, i[2].lightDir, weight.x),weight.y);
	#if defined(_USE_HIGHLIGHT)
	o.reflectionDir = lerp(lerp(i[0].reflectionDir, i[1].reflectionDir, weight.x), lerp(i[3].reflectionDir, i[2].reflectionDir, weight.x),weight.y);
	#endif
	o.normalDirOrg = lerp(lerp(i[0].normalDirOrg, i[1].normalDirOrg, weight.x), lerp(i[3].normalDirOrg, i[2].normalDirOrg, weight.x),weight.y);
	
	//頂点計算
	o.vertex = lerp(lerp(i[0].vertex, i[1].vertex, weight.x), lerp(i[3].vertex, i[2].vertex, weight.x),weight.y);
	#if defined(_USE_TESS_PHONG)
	//phong式
	float3 phongPos[4];
	phongPos[0] = o.vertex - dot((o.vertex - i[0].vertex), i[0].normalDirOrg) * i[0].normalDirOrg * _TessStrong;
	phongPos[1] = o.vertex - dot((o.vertex - i[1].vertex), i[1].normalDirOrg) * i[1].normalDirOrg * _TessStrong;
	phongPos[2] = o.vertex - dot((o.vertex - i[2].vertex), i[2].normalDirOrg) * i[2].normalDirOrg * _TessStrong;
	phongPos[3] = o.vertex - dot((o.vertex - i[3].vertex), i[3].normalDirOrg) * i[3].normalDirOrg * _TessStrong;
	o.vertex = float4(lerp(lerp(phongPos[0], phongPos[1], weight.x), lerp(phongPos[3], phongPos[2], weight.x),weight.y), 1);
	#endif
	//マップ
	#if defined(_USE_TESS_MAP)
	float _TessHightMap_var = tex2Dlod(_TessHightMap, float4(o.uv0*_TessHightFact,0,0)).r;
	#if defined(_USE_ADDITIONALFRILL)
	_TessHightMap_var *= (1-o.uv0.y)*(1-o.uv0.y);
	#endif
	o.vertex += float4(o.normalDirOrg,0)*_TessHightMap_var*_TessHightRate;
	#endif
	o.pos = UnityObjectToClipPos(o.vertex);
	o.posWorld = mul(unity_ObjectToWorld, o.vertex);
	
	return o;
}
#else
struct TessellationFactor {
	float tessFactor[PATCH_SIZE] : SV_TessFactor;
	float insideTessFactor : SV_InsideTessFactor;
};
TessellationFactor hullConst(InputPatch<VertexOutput, PATCH_SIZE> i) {
	float4 tessFactor = UnityDistanceBasedTess(i[0].vertex, i[1].vertex, i[2].vertex, _TessDistMin, _TessDistMax, _TessFactor);
	TessellationFactor o;
	o.tessFactor[0] = tessFactor.x;
	o.tessFactor[1] = tessFactor.y;
	o.tessFactor[2] = tessFactor.z;
	o.insideTessFactor = tessFactor.w;
	return o;
}
[domain("tri")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(PATCH_SIZE)]
[patchconstantfunc("hullConst")]
VertexOutput hull(InputPatch<VertexOutput, PATCH_SIZE> i, uint id:SV_OutputControlPointID) {
	return i[id];
}
[domain("tri")]
VertexOutput domain(TessellationFactor hullConst, const OutputPatch<VertexOutput, PATCH_SIZE> i, float3 weight:SV_DomainLocation) {
	VertexOutput o = i[0];
	o.uv0 = i[0].uv0 * weight.x + i[1].uv0 * weight.y + i[2].uv0 * weight.z;
	#if defined(_USE_ADDITIONAL) || defined(_FURNUM) || defined(_USE_GEOM_FUR)
	o.uv1 = i[0].uv1 * weight.x + i[1].uv1 * weight.y + i[2].uv1 * weight.z;
	#endif
	o.normalDir = i[0].normalDir * weight.x + i[1].normalDir * weight.y + i[2].normalDir * weight.z;
	#if defined(_USE_NORMALMAP)
	o.tangentDir = i[0].tangentDir * weight.x + i[1].tangentDir * weight.y + i[2].tangentDir * weight.z;
	o.bitangentDir = i[0].bitangentDir * weight.x + i[1].bitangentDir * weight.y + i[2].bitangentDir * weight.z;
	#endif
	o.col = i[0].col * weight.x + i[1].col * weight.y + i[2].col * weight.z;
	o.viewDir = i[0].viewDir * weight.x + i[1].viewDir * weight.y + i[2].viewDir * weight.z;
	o.lightDir = i[0].lightDir * weight.x + i[1].lightDir * weight.y + i[2].lightDir * weight.z;
	#if defined(_USE_HIGHLIGHT)
	o.reflectionDir = i[0].reflectionDir * weight.x + i[1].reflectionDir * weight.y + i[2].reflectionDir * weight.z;
	#endif
	o.normalDirOrg = i[0].normalDirOrg * weight.x + i[1].normalDirOrg * weight.y + i[2].normalDirOrg * weight.z;
	
	//頂点計算
	float3 vertex = i[0].vertex * weight.x + i[1].vertex * weight.y + i[2].vertex * weight.z;
	//phong式
	float3 phongPos	= weight[0] * (vertex - dot((vertex - i[0].vertex), i[0].normalDirOrg) * i[0].normalDirOrg * _TessStrong)
					+ weight[1] * (vertex - dot((vertex - i[1].vertex), i[1].normalDirOrg) * i[1].normalDirOrg * _TessStrong)
					+ weight[2] * (vertex - dot((vertex - i[2].vertex), i[2].normalDirOrg) * i[2].normalDirOrg * _TessStrong);
	o.vertex = float4(phongPos, 1);
	//マップ
	#if defined(_USE_TESS_MAP)
	float _TessHightMap_var = tex2Dlod(_TessHightMap, float4(o.uv0*_TessHightFact,0,0)).r;
	#if defined(_USE_ADDITIONALFRILL)
	_TessHightMap_var *= (1-o.uv0.y)*(1-o.uv0.y);
	#endif
	o.vertex += float4(o.normalDirOrg,0)*_TessHightMap_var*_TessHightRate;
	#endif
	o.pos = UnityObjectToClipPos(o.vertex);
	o.posWorld = mul(unity_ObjectToWorld, o.vertex);
	
	return o;
}
#endif
#endif

#endif