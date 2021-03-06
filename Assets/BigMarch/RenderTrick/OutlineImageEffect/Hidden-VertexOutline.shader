// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/VertexOutline"
{
	Properties
	{
	}
	
	SubShader
	{		
		Pass
		{
			Name "0"

			Stencil
			{
				Ref[_StencilRef]
				Comp[_StencilComp]
				Pass[_StencilPass]
				ZFail[_StencilZFail]
			}

			Tags{ "LightMode" = "ForwardBase" "Queue" = "Transparent" "IgnoreProjectors" = "True" "RenderType" = "Transparent" }

			Cull Front
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual

			CGPROGRAM
			
			#include "UnityCG.cginc"
			#pragma multi_compile TCP2_NONE TCP2_ZSMOOTH_ON
			#pragma multi_compile TCP2_NONE TCP2_OUTLINE_CONST_SIZE

			#pragma vertex TCP2_Outline_Vert
			#pragma fragment TCP2_Outline_Frag
			
			float _Outline;
			float _ZSmooth;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			v2f TCP2_Outline_Vert(a2v v)
			{
				_Outline = 0.75;

				v2f o;
/*
				//Correct Z artefacts
#if TCP2_ZSMOOTH_ON
				float4 pos = mul(UNITY_MATRIX_MV, v.vertex);
				float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				normal.z = -_ZSmooth;

	#ifdef TCP2_OUTLINE_CONST_SIZE
				//Camera-independent outline size
				float dist = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));
				pos = pos + float4(normalize(normal), 0) * _Outline * 0.01 * dist;
	#else
				pos = pos + float4(normalize(normal), 0) * _Outline * 0.01;
	#endif

#else

				float3 normal = v.normal;

				//Camera-independent outline size
	#ifdef TCP2_OUTLINE_CONST_SIZE
				float dist = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));
				float4 pos = mul(UNITY_MATRIX_MV, v.vertex + float4(normal, 0) * _Outline * 0.01 * dist);
	#else
				float4 pos = mul(UNITY_MATRIX_MV, v.vertex + float4(normal, 0) * _Outline * 0.01);
	#endif

#endif
*/
				// 跟距离有关关的顶点外拓，const size。
			/*	float3 normal = v.normal;
				float dist = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));
				float3 pos = UnityObjectToViewPos(v.vertex.xyz + normal * _Outline * 0.01 * dist);
				o.pos = mul(UNITY_MATRIX_P, float4(pos.xyz, 1));*/

				/*
				// 计算距离
				//float dist = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));
				// 世界空间的法线
				float3 normalInWorld = UnityObjectToWorldNormal(v.normal);
				// 摄像机空间的法线
				float4 normalInView = mul(UNITY_MATRIX_V, fixed4(normalInWorld, 0.0));
				// 摄像机空间的法线
				float3 posInView = UnityObjectToViewPos(v.vertex.xyz);			
				// 顶点在摄像机空间外展，abs(posInView.z)为什么要取绝对值，没想明白。
				posInView += float3(normalInView.xy, 0) * _Outline * 0.01 * abs(posInView.z);
				// 顶点位置输出
				o.pos = mul(UNITY_MATRIX_P, float4(posInView.xyz, 1));*/

				/*
				// 计算距离
				//float dist = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));
				// 世界空间的法线
				float3 normalInWorld = UnityObjectToWorldNormal(v.normal);
				// 摄像机空间的法线
				float4 normalInP = mul(UNITY_MATRIX_VP, fixed4(normalInWorld, 0.0));
				// 摄像机空间的法线
				float3 posInView = UnityObjectToViewPos(v.vertex.xyz);
				// 顶点位置输出
				o.pos = mul(UNITY_MATRIX_P, float4(posInView.xyz, 1));

				float4 delta = float4(normalInP.xy, 0, 0) * _Outline * 0.01;// *abs(posInView.z);

				// 顶点在摄像机空间外展，abs(posInView.z)为什么要取绝对值，没想明白。
				o.pos += delta;
				*/

				// 获取模型的最终的投影坐标  
				o.pos = UnityObjectToClipPos(v.vertex);
				// UNITY_MATRIX_IT_MV为【模型坐标-世界坐标-摄像机坐标】【专门针对法线的变换】  
				// 法线乘以MV，将模型空间 转换 视图空间  
				float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				// 转换 视图空间 到 投影空间 【3D转2D】  
				float2 offset = TransformViewToProjection(norm.xy);
				// 得到的offset，模型被挤的非常大，然后乘以倍率  
				o.pos.xy += normalize(offset) * 0.01 * _Outline * o.pos.w;
				return o;
			}

			float4 TCP2_Outline_Frag(v2f IN) : COLOR
			{
				return float4(1,1,1,1);
			}
						
			ENDCG
		}
	}
}
