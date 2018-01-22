Shader "Custom/MetaballCast" {
	Properties {}
	SubShader {
		//Tags { "RenderType"="Opaque" }
		Tags {"Queue" = "Transparent" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Unlit noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nofog nometa

		float4 metaballs[64]; // x,y,z,radius
		sampler2D _CameraDepthTexture; //Depth Texture

		struct Input {
			float3 viewDir;
			float3 worldPos;
			float4 screenPos;
		};

      	half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
      		return half4(s.Albedo, s.Alpha);
     	}

		float sphereDistance(float3 p, float3 sphere_pos, float sphere_radius) {
			float d = distance(p, sphere_pos);
			return (sphere_radius * sphere_radius) / (d * d);
		}

		fixed4 raymarch (float3 position, float3 direction, float maxDepth)
		{
			int _Steps = 500;
			float step_size = 0.1;
			 for (int i = 0; i < _Steps; i++)
			 {
				if (i * step_size > maxDepth) { break; } // Respect Depth Buffer

			 	float sum = 0.0;
			 	for(int j = 0; j < 64; j++) {
			 		if (metaballs[j].w < 0.1) { break; } // This metaball doesn't exist
			 		sum += sphereDistance(position, metaballs[j].xyz, metaballs[j].w);
			 	}
				 if(sum > 1) return fixed4(0, 0, 1, 1);
				 
				 position += direction * step_size;
			 }
			discard;
		 return fixed4(1, 1, 1, 0);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float sceneZ = LinearEyeDepth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos)).r); // Z position of current depth buffer
			float startZ = distance(_WorldSpaceCameraPos, IN.worldPos); // Z position from camera where raymarch begins
			o.Albedo = raymarch(IN.worldPos, -IN.viewDir, sceneZ - startZ).xyz;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
