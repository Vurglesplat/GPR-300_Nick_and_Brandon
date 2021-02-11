/*
	Copyright 2011-2021 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawLambert_fs4x.glsl
	Output Lambertian shading.
*/

#version 450

// ****TO-DO: 
//	-> declare varyings to receive lighting and shading variables
//	x-> declare lighting uniforms
//		(hint: in the render routine, consolidate lighting data 
//		into arrays; read them here as arrays)
//	x-> calculate Lambertian coefficient
//	-> implement Lambertian shading model and assign to output
//		(hint: coefficient * attenuation * light color * surface color)
//	-> implement for multiple lights
//		(hint: there is another uniform for light count)

uniform vec4 uLightPos; 
uniform vec4 ulColor;
uniform float ulRadius;

uniform sampler2D uTex_dm;
uniform vec4 uColor; 


layout (location = 0) out vec4 rtFragColor;

in vec4 vNormal;
in vec4 vPosition;
in vec2 vTexCoord; 

void main()
{
 	vec4 tex = texture(uTex_dm, vTexCoord); 

	vec4 N = normalize(vNormal);
	vec4 L = uLightPos - vPosition;
	float lightDistance = length(L);
	L = L/lightDistance; //This normalizes L WITHOUT using the normalize function
						 // which would have called length() again, and we are using it later for attenuation
	
	
	
	float lmbCoeff = dot(N, L);
	float attenuation = mix(1.0,0.0,lightDistance/(ulRadius*ulRadius));

	vec4 result = tex * uColor * ulColor * lmbCoeff * attenuation;
	rtFragColor = vec4(result.rgb,1.0); // this is grayscale based on the lmbCoeff value
}
