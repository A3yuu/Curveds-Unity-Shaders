Shader "A3/Crack"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Culling", Int) = 2
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		// Blending state
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("__src", Float) = 1.0
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("__dst", Float) = 0.0
		_ZWrite ("__zw", Float) = 1.0
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
			"Queue" = "Geometry-2000"
		}
		Pass
		{
			Cull [_Cull]
			ZWrite [_ZWrite]
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			CGPROGRAM
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform float4 _Color;
			struct VertexOutput
			{
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float4 posWorld : TEXCOORD2;
				float3 normalDir : NORMAL;
				SHADOW_COORDS(4)
				UNITY_FOG_COORDS(5)
				float3 lightDir : TEXCOORD7;
			};
			VertexOutput vert(appdata_base v)
			{
				VertexOutput o;
				o.uv0 = v.texcoord;
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.lightDir = normalize(lerp(float3(0.0, 1.0, 0.0), lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - o.posWorld.xyz, _WorldSpaceLightPos0.w), any(_WorldSpaceLightPos0.xyz)));
				TRANSFER_SHADOW(o);
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}
			fixed4 frag (VertexOutput i) : SV_Target
			{
				float4 baseColor = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex))*_Color;
				float3 normalDirection = normalize(i.normalDir);
				float3 lightDirection = i.lightDir;
				float3 lightColor = _LightColor0.rgb;
				UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);
				float lightContribution = dot(lightDirection, normalDirection)*attenuation;
				float3 directContribution = saturate((1.0 - 0.5) * attenuation + saturate(lightContribution*2.0-0.5));
				float3 lighting = lerp(0, lightColor, directContribution);
				float3 finalColor = baseColor.rgb * lighting;
				fixed4 finalRGBA = fixed4(finalColor, baseColor.a);
				UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				return finalRGBA;
			}
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
}
