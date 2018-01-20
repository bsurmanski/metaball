Shader "Custom/MetaballCast" {
	Properties {}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Unlit noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nofog nometa

		float4 metaballs[10]; // x,y,z,radius

		struct Input {
			float3 viewDir;
			float3 worldPos;
		};

          half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
          	  return half4(s.Albedo, s.Alpha);
          }

		float sphereDistance(float3 p, float3 sphere_pos, float sphere_radius) {
			float d = distance(p, sphere_pos);
			return (sphere_radius * sphere_radius) / (d * d);
		}

		fixed4 raymarch (float3 position, float3 direction)
		{
			int _Steps = 500;
			float step_size = 0.02;
			 for (int i = 0; i < _Steps; i++)
			 {
			 	float sum = 0.0;
			 	for(int j = 0; j < 10; j++) {
			 		sum += sphereDistance(position, metaballs[j].xyz, metaballs[j].w);
			 	}
				 if(sum > 1) return fixed4(direction, 1);
				 
				 position += direction * step_size;
			 }
		 return fixed4(1,1,1,1);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = raymarch(IN.worldPos, -IN.viewDir).xyz;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
