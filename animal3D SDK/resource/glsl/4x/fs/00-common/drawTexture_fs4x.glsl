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
	
	drawTexture_fs4x.glsl
	Output texture blended with color.
*/

#version 450

// ****DONE: 
//	-> declare texture coordinate varying
//	-> declare sampler uniform
//		(hint: correct name is used in codebase)
//	-> get color from sampler at texture coordinate
//	-> assign color to output
uniform vec4 uColor;
// taking it in as a sampler in order to easily pull it via texture
uniform sampler2D uTex_dm;

layout (location = 0) out vec4 rtFragColor;

in vec2 vTexCoord;

void main()
{
	vec4 tex = texture(uTex_dm, vTexCoord);

	// multiplication is used to "tint" the texture the color
	rtFragColor =  tex * uColor;
}
