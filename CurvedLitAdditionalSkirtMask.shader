Shader "A3/Mask/CurvedLitAdditionalSkirt"
{
	Properties
	{
		_Mask("Mask", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _Comp ("Comp", Int) = 3
		[Space]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Culling", Int) = 2
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		[Space]
		_Shadow("Shadow", Range(0, 1)) = 0.4
		_ShadowMag("Shadow Mag", Range(0, 10)) = 2.0
		_ShadowOffset("Shadow Offset", Range(-10, 10)) = -0.5
		[Toggle(_USE_INDIRECTLIGHTING)]
		_UseIndirectlighting("Use Indirectlighting", Float) = 1
		[Toggle(_USE_REFLECTION)]
		_UseReflection("Use Reflection", Float) = 1
		_ReflectionPower("Reflection Power", Range(0, 10)) = 7
		_Reflection("Reflection", Range(0, 1)) = 0.02
		[Space]
		[Toggle(_USE_EMISSION)]
		_UseEmission("Use Emission", Float) = 0
		_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,1)
		[Space]
		[Toggle(_USE_NORMALMAP)]
		_UseNormalmap("Use Normal Map", Float) = 0
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Cutoff("Alpha Cutoff", Range(0,1)) = 0.5
		[Space]
		[Toggle(_USE_HIGHLIGHT)]
		_UseHighLight("Use HighLight", Float) = 0
		_HighLightColor( "HighLight Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_HighLightPower( "HighLight Power", Range( 0, 10.0 )) = 7.0
		_HighLightMag( "HighLight Mag", Range( 0, 1.0 )) = 0.5
		_HighLightTex ("HighLight Tex", 2D) = "white" {}
		[Space]
		[Toggle(_USE_HAIRLIGHT)]
		_UseHairLight("Use HairLight", Float) = 0
		_HairLightColor( "HairLight Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_HairLightTex ("HairLight Tex", 2D) = "white" {}
		[Space]
		[Toggle(_USE_RIM)]
		_UseRim("Use Rim", Float) = 0
		_RimColor( "Rim Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_RimPower( "Rim Power", Range( 0, 10.0 )) = 3.0
		_RimLightTex ("Rim Tex", 2D) = "white" {}
		[Space]
		_AdditionalTex ("Additional Tex", 2D) = "white" {}
		_AdditionalMask ("Additional Mask", 2D) = "white" {}
		_AdditionalLace("Additional Lace", 2D) = "white" {}
		_AdditionalFrill("Additional Frill", 2D) = "white" {}
		_AdditionalAdd("Additional Add", 2D) = "white" {}
		_AdditionalLaceNum("AdditionalLaceNum", Float) = 1
		_AdditionalAddNum("AdditionalAddNum", Float) = 1
		[Space]
		_TessHightMap("TessHightMap", 2D) = "white" {}
		_TessHightRate("TessHightRate", Float) = 1
		_TessHightFact("TessHightFact", Float) = 1
		[Space]
		_TessStrong("Tess Strong",Range( 0, 2 )) = 1
		_TessDistMin("Tess Dist Min",Float) = 0.2
		_TessDistMax("Tess Dist Max",Float) = 2
		_TessFactor("Tess Factor",Range( 0, 64 )) = 16
		[Space]
		// Blending state
		_Mode ("__mode", Float) = 0.0
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("__src", Float) = 1.0
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("__dst", Float) = 0.0
		_ZWrite ("__zw", Float) = 1.0
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "TransparentCutout"
		}

		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _USE_ADDITIONAL
			#define _ALPHATEST_ON
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _USE_HAIRLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 4.0
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			
			
			ENDCG
		}
		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _USE_ADDITIONALADD
			#define _ALPHATEST_ON
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _USE_HAIRLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 4.0
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			
			
			ENDCG
		}
		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#undef _USE_ADDITIONAL
			#define _USE_ADDITIONALSKIRT
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _USE_HAIRLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 4.0
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			
			
			ENDCG
		}
		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _USE_ADDITIONALFRILL
			#define _USE_NORMALMAP
			#define _USE_TESSELLATION
			#define _TESSELLATION_QUAD
			#define _USE_TESS_MAP
			#pragma hull hull
			#pragma domain domain
			#define _ALPHATEST_ON
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _USE_HAIRLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 5.0
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			
			
			ENDCG
		}
		
		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _PASS_FORWARDADD
			#define _ALPHATEST_ON
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 4.0
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog
			ENDCG
		}
		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _USE_ADDITIONALADD
			#define _PASS_FORWARDADD
			#define _ALPHATEST_ON
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 4.0
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog
			ENDCG
		}
		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _USE_ADDITIONALSKIRT
			#define _PASS_FORWARDADD
			#define _ALPHATEST_ON
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 4.0
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog
			ENDCG
		}
		Pass
		{
			Stencil 
			{
				Ref [_Mask]
				Comp [_Comp]
			}
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _USE_ADDITIONALFRILL
			#define _USE_NORMALMAP
			#define _USE_TESSELLATION
			#define _TESSELLATION_QUAD
			#define _USE_TESS_MAP
			#pragma hull hull
			#pragma domain domain
			#define _PASS_FORWARDADD
			#define _ALPHATEST_ON
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_HIGHLIGHT
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#include "CurvedLitCore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d11 glcore gles
			#pragma target 5.0
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog
			ENDCG
		}
	}
	FallBack "Diffuse"
}
