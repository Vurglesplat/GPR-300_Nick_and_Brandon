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
	
	postBlur_fs4x.glsl
	Gaussian blur.
*/

#version 450

// ****DONE:
//	-> declare texture coordinate varying and input texture
//	-> declare sampling axis uniform (see render code for clue)
//	-> declare Gaussian blur function that samples along one axis
//		(hint: the efficiency of this is described in class)

in vec4  vTexcoord_atlas;
uniform sampler2D uTex_dm;
uniform vec2 uAxis;
layout (location = 0) out vec4 rtFragColor;


// 1/16 * [ 1 4 6 4 1 ]
//uniform float weight[5] = float[] (0.0625, 0.25, 0.375, 0.25, 0.0625);

void main()
{
	//starts with the original color of the pixel
	vec4 finalColor =  texture(uTex_dm, vTexcoord_atlas.xy);
	// before adding the colors of the adjacent pixels
	finalColor += texture(uTex_dm, vec2(vTexcoord_atlas.x + uAxis.x, vTexcoord_atlas.y + uAxis.y));
	finalColor += texture(uTex_dm, vec2(vTexcoord_atlas.x - uAxis.x, vTexcoord_atlas.y - uAxis.y));
	// averaginging the color between them
	rtFragColor = finalColor/3.0f;	
}
