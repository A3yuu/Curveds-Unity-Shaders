Shader "A3/Window"
{
	Properties
	{
		_Mask ("Mask", Int) = 1
		[KeywordEnum(Off, Front, Back)] _Cull("Culling", Int) = 2
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "TransparentCutout"
			"Queue" = "Geometry-2"
		}
		
		Pass
		{
			ColorMask 0
			ZWrite Off
			Stencil 
			{
				Ref [_Mask]
				Comp Always
				Pass Replace
			}
			Cull [_Cull]
			CGPROGRAM
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert(appdata_base v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			fixed4 frag (v2f i) : SV_Target
			{
				return 0;
			}
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
}
