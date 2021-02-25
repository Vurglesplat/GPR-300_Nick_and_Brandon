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
	
	postBlend_fs4x.glsl
	Blending layers, composition.
*/

#version 450

// ****DONE:
//	-> declare texture coordinate varying and set of input textures
//	-> implement some sort of blending algorithm that highlights bright areas
//		(hint: research some Photoshop blend modes)

layout (location = 0) out vec4 rtFragColor;

in vec4 vTexcoord_atlas;
uniform sampler2D uTex_dm;

uniform sampler2D uImage00, uImage01, uImage02, uImage03;

void main()
{
	// this used Dan Buckstein's Lecture 5 on bloom as a basis, specifically the algorithm: screen(A,B,C,D) = 1 - (1-A)(1-B)(1-C)(1-D)

	// inverting each texture, and then multiplying them (inverted so that the dark values intensify each other)
	vec4 color  = vec4(1.0) - texture(uImage00, vTexcoord_atlas.xy);
		 color *= vec4(1.0) - texture(uImage00, vTexcoord_atlas.xy);
		 color *= vec4(1.0) - texture(uImage02, vTexcoord_atlas.xy);
		 color *= vec4(1.0) - texture(uImage03, vTexcoord_atlas.xy);

	color = vec4(1.0) - color;
	rtFragColor = color;
}
