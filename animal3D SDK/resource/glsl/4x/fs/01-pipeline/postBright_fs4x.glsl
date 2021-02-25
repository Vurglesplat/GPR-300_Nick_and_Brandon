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
	
	postBright_fs4x.glsl
	Bright pass filter.
*/

#version 450

// ****TO-DO:
//	-> declare texture coordinate varying and input texture
//	-> implement relative luminance function
//	-> implement simple "tone mapping" such that the brightest areas of the 
//		image are emphasized, and the darker areas get darker

uniform vec4 uColor;
uniform sampler2D uTex_dm;

layout (location = 0) out vec4 rtFragColor;

in vec4 vTexcoord_atlas;

void main()
{
	vec4 tex = texture(uTex_dm, vTexcoord_atlas.xy);
	vec4 tintedTex = tex * uColor;

	float luminance = dot(tintedTex.rgb, vec3(0.3, 0.59, 0.11)); 
	//Note: looking at the slides and comparing it to photoshop's effects, 
	//it appears the luminance is a weighted greyscale.

	float bright = -cos(luminance*3.14159265/2)+1; //Cosine curve
	//float bright = 1 - sqrt(1 - luminance * luminance); //Circle curve
	//float bright = pow(luminance,2); //Basic parabola

	//rtFragColor =  tintedTex * exposure;
	rtFragColor.rgb = tintedTex.rgb * bright;    
	rtFragColor.a = 1.0f;
}
