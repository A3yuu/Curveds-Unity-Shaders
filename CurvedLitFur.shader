Shader "A3/CurvedLitFur"
{
	Properties
	{
		[KeywordEnum(Off, Front, Back)] _Cull("Culling", Int) = 2
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		[Toggle(_USE_COLORMASK)]
		_UseColorMask("Use Color Mask", Float) = 0
		_ColorMask("Color Mask", 2D) = "black" {}
		_Shadow("Shadow", Range(0, 1)) = 0.4
		_ShadowMag("Shadow Mag", Range(0, 10)) = 2.0
		_ShadowOffset("Shadow Offset", Range(-10, 10)) = -0.5
		[Toggle(_USE_INDIRECTLIGHTING)]
		_UseIndirectlighting("Use Indirectlighting", Float) = 1
		[Toggle(_USE_REFLECTION)]
		_UseReflection("Use Reflection", Float) = 1
		_ReflectionPower("Reflection Power", Range(0, 10)) = 7
		_Reflection("Reflection", Range(0, 1)) = 0.02
		[Toggle(_USE_EMISSION)]
		_UseEmission("Use Emission", Float) = 0
		_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,1)
		[Toggle(_USE_NORMALMAP)]
		_UseNormalmap("Use Normal Map", Float) = 0
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Cutoff("Alpha Cutoff", Range(0,1)) = 0.5
		[Toggle(_USE_HIGHLIGHT)]
		_UseHighLight("Use HighLight", Float) = 0
		_HighLightColor( "HighLight Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_HighLightPower( "HighLight Power", Range( 0, 10.0 )) = 1.0
		_HighLightTex ("HighLight Tex", 2D) = "white" {}
		[Toggle(_USE_RIM)]
		_UseRim("Use Rim", Float) = 0
		_RimColor( "Rim Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_RimPower( "Rim Power", Range( 0, 10.0 )) = 3.0
		_RimLightMask ("Rim Mask", 2D) = "white" {}
		_FurTex  ("FurMap", 2D) = "white" {}
		_FurGravity ("FurGravity", Vector) = (0.0, 9.8, 0.0, 0.0)
		_FurLength ("FurLength", Range(0, 1)) = 0.03
		_FurFact ("FurFact", Range(0, 10)) = 1

		// Blending state
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}

		Pass
		{
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.1
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.2
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.3
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.4
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.5
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.6
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.7
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.8
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.9
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 1
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
			#pragma shader_feature _USE_REFLECTION
			#pragma shader_feature _USE_INDIRECTLIGHTING
			#pragma shader_feature _USE_EMISSION
			#pragma shader_feature _USE_RIM
			#pragma shader_feature _USE_HIGHLIGHT
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.1
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.2
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.3
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.4
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.5
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.6
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.7
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.8
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 0.9
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Cull [_Cull]
			CGPROGRAM
			#define _FURNUM 1
			#define _PASS_FORWARDADD
			#pragma shader_feature _USE_NORMALMAP
			#pragma shader_feature _USE_COLORMASK
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
	}
	FallBack "Diffuse"
}
