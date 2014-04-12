Shader "ShaderMan/MultitexturingGL" 
{
	Properties 
	{
		_EarthDayMap ("Earth Day Map", 2D) = "white" {}
		_EarthNightMap ("Earth Night Map", 2D) = "white" {}
		_EarthCloudsGlossMap ("Earth Clouds Gloss Map", 2D) = "white" {}
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
			
			uniform sampler2D _EarthDayMap;
			uniform sampler2D _EarthNightMap;
			uniform sampler2D _EarthCloudsGlossMap;
		
			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying float Diffuse;
			varying vec3 Specular;
			
			#ifdef VERTEX
						
			void main ()
			{
				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				vec3 worldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));
				vec3 worldSpaceLightDirection = normalize (_WorldSpaceLightPos0.xyz - worldSpacePosition);
				vec3 worldSpaceReflectedDirection = reflect (-worldSpaceLightDirection, worldSpaceNormal);
				vec3 worldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);
			
				float specular = clamp (dot (worldSpaceReflectedDirection, worldSpaceViewDirection), 0.0, 1.0);
				specular = pow (specular, 16.0);
				Specular = specular * vec3 (1.0, 0.941, 0.898) * 0.3; // Approximate color of sunlight
				
				Diffuse = max (dot (worldSpaceLightDirection, worldSpaceNormal), 0.0);
							
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
			
			#ifdef FRAGMENT
			
			void main ()
			{
				// Monochrome cloud cover value will be in clouds.r
				// Gloss value will be in clouds.g
				// clouds.b will be unsed
				vec2 clouds = texture2D (_EarthCloudsGlossMap, gl_TexCoord[0].xy).rg;
				vec3 daytimeColor = (texture2D (_EarthDayMap, gl_TexCoord[0].xy).rgb * Diffuse + Specular * clouds.g) * (1.0 - clouds.r) + clouds.r * Diffuse;
				vec3 nighttimeColor = texture2D (_EarthNightMap, gl_TexCoord[0].xy).rgb * (1.0 - clouds.r) * 2.0;
				
				// Final color
				vec3 color = daytimeColor;
				if (Diffuse < 0.1)
				{
					color = mix (nighttimeColor, daytimeColor, (Diffuse + 0.1) * 5.0);
				}
				
				gl_FragColor = vec4 (color, 1.0);
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
			
			uniform sampler2D _EarthDayMap;
			uniform sampler2D _EarthNightMap;
			uniform sampler2D _EarthCloudsGlossMap;
		
			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying float Diffuse;
			varying vec3 Specular;
			
			#ifdef VERTEX
						
			void main ()
			{
				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				vec3 worldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));
				vec3 worldSpaceLightDirection = normalize (_WorldSpaceLightPos0.xyz - worldSpacePosition);
				vec3 worldSpaceReflectedDirection = reflect (-worldSpaceLightDirection, worldSpaceNormal);
				vec3 worldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);
			
				float specular = clamp (dot (worldSpaceReflectedDirection, worldSpaceViewDirection), 0.0, 1.0);
				specular = pow (specular, 16.0);
				Specular = specular * vec3 (1.0, 0.941, 0.898) * 0.3; // Approximate color of sunlight
				
				Diffuse = max (dot (worldSpaceLightDirection, worldSpaceNormal), 0.0);
							
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
			
			#ifdef FRAGMENT
			
			void main ()
			{
				// Monochrome cloud cover value will be in clouds.r
				// Gloss value will be in clouds.g
				// clouds.b will be unsed
				vec2 clouds = texture2D (_EarthCloudsGlossMap, gl_TexCoord[0].xy).rg;
				vec3 daytimeColor = (texture2D (_EarthDayMap, gl_TexCoord[0].xy).rgb * Diffuse + Specular * clouds.g) * (1.0 - clouds.r) + clouds.r * Diffuse;
				vec3 nighttimeColor = texture2D (_EarthNightMap, gl_TexCoord[0].xy).rgb * (1.0 - clouds.r) * 2.0;
				
				// Final color
				vec3 color = daytimeColor;
				if (Diffuse < 0.1)
				{
					color = mix (nighttimeColor, daytimeColor, (Diffuse + 0.1) * 5.0);
				}
				
				gl_FragColor = vec4 (color, 1.0);
			}
			
			#endif
			
			ENDGLSL
		}
	} 
   // The definition of a fallback shader should be commented out 
   // during development:
   // Fallback "Diffuse"
}