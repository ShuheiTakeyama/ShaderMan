Shader "ShaderMan/HemisphereLightingGL" 
{
	Properties 
	{
		_ColorMap ("Color Map", 2D) = "white" {}
		_GroundColor ("Ground Color", Color) = (0.2, 0.2, 0.2, 1.0)
		_SkyColor ("Sky Color", Color) = (0.9, 0.9, 1.0, 1.0)
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
			
			uniform sampler2D _ColorMap;
			uniform vec4 _GroundColor;
			uniform vec4 _SkyColor;
		
			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying vec3 Color;
			
			const float SpecularContribution = 0.1;
			const float DiffuseContribution = 1.0 - SpecularContribution;
			
			#ifdef VERTEX
						
			void main ()
			{
				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				vec3 worldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));
				vec3 worldSpaceLightDirection = normalize (_WorldSpaceLightPos0.xyz);
				vec3 worldSpaceReflectedDirection = reflect (-worldSpaceLightDirection, worldSpaceNormal);
				vec3 worldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);
			
				float diffuse = DiffuseContribution * max (dot (worldSpaceLightDirection, worldSpaceNormal), 0.0);			
				float specular = SpecularContribution * pow (clamp (dot (worldSpaceReflectedDirection, worldSpaceViewDirection), 0.0, 1.0), 16.0);
				Color = vec3 (mix (_GroundColor, _SkyColor, diffuse)); // + _SkyColor * specular);
			
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
			
			#ifdef FRAGMENT
			
			void main ()
			{
				gl_FragColor = vec4 (vec3 (texture2D (_ColorMap, gl_TexCoord[0].xy)) * Color, 1.0);
			}
			
			#endif
			
			ENDGLSL
		}
	} 
   // The definition of a fallback shader should be commented out 
   // during development:
   // Fallback "Diffuse"
}