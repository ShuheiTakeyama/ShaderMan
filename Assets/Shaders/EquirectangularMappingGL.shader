Shader "ShaderMan/EquirectangularMappingGL" 
{
	Properties 
	{
		_BaseColor ("Base Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MixRatio ("Mix Ratio", Range (0.0, 1.0)) = 0.7
		_EnvironmentMap ("Environment Map", 2D) = "white" {}
		_Lod ("Lod", FLOAT) = 0.0
	}
	
	SubShader 
	{			
		Pass
		{
			Tags
			{ 
				"LightMode" = "ForwardBase"
			}
		
			GLSLPROGRAM
			
			uniform vec4 _BaseColor;
			uniform float _MixRatio;
			uniform sampler2D _EnvironmentMap;
			uniform float _Lod;

			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying float LightIntensity;
			varying vec3 WorldSpaceNormal;
			varying vec3 WorldSpaceViewDirection;
			
			#ifdef VERTEX
						
			void main ()
			{
				WorldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));
				
				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				WorldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);
				
				vec3 worldSpaceLightDirection = normalize (_WorldSpaceLightPos0.xyz - worldSpacePosition);			
				LightIntensity = max (dot (worldSpaceLightDirection, WorldSpaceNormal), 0.0);
			
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
						
			#ifdef FRAGMENT
			
			const float kPI = 3.141592653589793;

			void main ()
			{
				// Compute reflection vector
				vec3 reflectedDirection = reflect (-WorldSpaceViewDirection, WorldSpaceNormal);				
				reflectedDirection = normalize (reflectedDirection);

				// Sample environment map value in equirectangular texture
				float longitude = atan (reflectedDirection.z, reflectedDirection.x);
				float latitude = acos (-reflectedDirection.y);
				longitude /= 2.0 * kPI;
				latitude /= kPI;
				vec3 environmentColor = vec3 (texture2DLod (_EnvironmentMap, vec2 (longitude, latitude), _Lod));
				
				// Final color
				vec3 baseColor = LightIntensity * _BaseColor.rgb;
				
				gl_FragColor = vec4 (mix (baseColor, environmentColor, _MixRatio), 1.0);
			}
			
			#endif
			
			ENDGLSL
		}
		
		Pass
		{
			Tags
			{ 
				"LightMode" = "ForwardAdd"
			}
		
			Blend One One
			
			GLSLPROGRAM
			
			uniform vec4 _BaseColor;
			uniform float _MixRatio;
			uniform sampler2D _EnvironmentMap;
			uniform float _Lod;

			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying float LightIntensity;
			varying vec3 WorldSpaceNormal;
			varying vec3 WorldSpaceViewDirection;
			
			#ifdef VERTEX
						
			void main ()
			{
				WorldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));
				
				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				WorldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);
				
				vec3 worldSpaceLightDirection = normalize (_WorldSpaceLightPos0.xyz - worldSpacePosition);			
				LightIntensity = max (dot (worldSpaceLightDirection, WorldSpaceNormal), 0.0);
			
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
						
			#ifdef FRAGMENT
			
			const float kPI = 3.141592653589793;

			void main ()
			{
				// Compute reflection vector
				vec3 reflectedDirection = reflect (-WorldSpaceViewDirection, WorldSpaceNormal);				
				reflectedDirection = normalize (reflectedDirection);

				// Sample environment map value in equirectangular texture
				float longitude = atan (reflectedDirection.z, reflectedDirection.x);
				float latitude = acos (-reflectedDirection.y);
				longitude /= 2.0 * kPI;
				latitude /= kPI;
				vec3 environmentColor = vec3 (texture2DLod (_EnvironmentMap, vec2 (longitude, latitude), _Lod));
				
				// Final color
				vec3 baseColor = LightIntensity * _BaseColor.rgb;
				
				gl_FragColor = vec4 (mix (baseColor, environmentColor, _MixRatio), 1.0);
			}
			
			#endif
			
			ENDGLSL
		}
	} 
   // The definition of a fallback shader should be commented out 
   // during development:
   // Fallback "Diffuse"
}
