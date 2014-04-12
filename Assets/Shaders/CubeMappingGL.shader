Shader "ShaderMan/CubeMappingGL" 
{
	Properties 
	{
		_BaseColor ("Base Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MixRatio ("Mix Ratio", Range (0.0, 1.0)) = 0.7
		_EnvironmentMap ("Environment Map", CUBE) = "" {}
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
			uniform samplerCube _EnvironmentMap;
		
			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying float LightIntensity;
			varying vec3 ReflectedDirection;
			
			#ifdef VERTEX
						
			void main ()
			{
				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				vec3 worldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));
				vec3 worldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);

				ReflectedDirection = reflect (-worldSpaceViewDirection, worldSpaceNormal);				
				
				vec3 worldSpaceLightDirection = normalize (_WorldSpaceLightPos0.xyz - worldSpacePosition);			
				LightIntensity = max (dot (worldSpaceLightDirection, worldSpaceNormal), 0.0);
			
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
			
			#ifdef FRAGMENT
			
			void main ()
			{
				vec3 environmentColor = vec3 (textureCube (_EnvironmentMap, ReflectedDirection));
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
			uniform samplerCube _EnvironmentMap;
		
			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying float LightIntensity;
			varying vec3 ReflectedDirection;
			
			#ifdef VERTEX
						
			void main ()
			{
				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				vec3 worldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));
				vec3 worldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);

				ReflectedDirection = reflect (-worldSpaceViewDirection, worldSpaceNormal);				
				
				vec3 worldSpaceLightDirection = normalize (_WorldSpaceLightPos0.xyz - worldSpacePosition);			
				LightIntensity = max (dot (worldSpaceLightDirection, worldSpaceNormal), 0.0);
			
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
			
			#ifdef FRAGMENT
			
			void main ()
			{
				vec3 environmentColor = vec3 (textureCube (_EnvironmentMap, ReflectedDirection));
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
