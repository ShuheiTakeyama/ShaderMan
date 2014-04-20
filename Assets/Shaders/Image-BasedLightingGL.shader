Shader "ShaderMan/Image-BasedLightingGL" 
{
	Properties 
	{
		_ColorMap ("Color Map", 2D) = "white" {}
		_SpecularEnvironmentMap ("Specular Environment Map", CUBE) = "" {}
		_SpecularPercent ("SpecularPercent", Range (0.0, 1.0)) = 0.2
		_DiffuseEnvironmentMap ("Diffuse Environment Map", CUBE) = "" {}
		_DiffusePercent ("DiffusePercent", Range (0.0, 1.0)) = 0.8
		_Lod ("Lod", FLOAT) = 0.0
	}
	
	SubShader 
	{			
		Pass
		{
			GLSLPROGRAM
			
			uniform sampler2D _ColorMap;
			uniform vec4 _ColorMap_ST;
			uniform samplerCube _SpecularEnvironmentMap;
			uniform float _SpecularPercent;
			uniform samplerCube _DiffuseEnvironmentMap;
			uniform float _DiffusePercent;
			uniform float _Lod;
		
			uniform mat4 _Object2World;
			uniform mat4 _World2Object;
			uniform vec3 _WorldSpaceCameraPos;
			uniform vec4 _WorldSpaceLightPos0;
						
			varying vec3 WorldSpaceReflectedDirection;
			varying vec3 WorldSpaceNormal;
			
			#ifdef VERTEX
						
			void main ()
			{
				WorldSpaceNormal = normalize (vec3 (vec4 (gl_Normal, 0.0) * _World2Object));

				vec3 worldSpacePosition = vec3 (_Object2World * gl_Vertex);
				vec3 worldSpaceViewDirection = normalize (_WorldSpaceCameraPos - worldSpacePosition);
				WorldSpaceReflectedDirection = reflect (-worldSpaceViewDirection, WorldSpaceNormal);
			
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				gl_TexCoord[0] = gl_MultiTexCoord0;
			}
			
			#endif
			
			#ifdef FRAGMENT
			
			void main ()
			{
				// Look up environment map values in cube maps
				vec3 diffuseColor = vec3 (textureCube (_DiffuseEnvironmentMap, normalize (WorldSpaceNormal)));
				vec3 specularColor = vec3 (textureCubeLod (_SpecularEnvironmentMap, normalize (WorldSpaceReflectedDirection), _Lod));
				
				// Final color
				vec3 baseColor = vec3 (texture2D (_ColorMap, gl_TexCoord[0].xy * _ColorMap_ST.xy + _ColorMap_ST.zw));
				vec3 color = mix (baseColor, baseColor * diffuseColor, _DiffusePercent);
				color = mix (color, specularColor + color, _SpecularPercent);
				
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
