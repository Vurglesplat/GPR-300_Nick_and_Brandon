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
	
	tessIso_tcs4x.glsl
	Basic tessellation control for isolines.
*/

#version 450

// ****TO-DO: 
//	-> set tessellation levels, adjust as needed

//This specificies how many vertices are in the patch, technically makes the first line we added in idle-render a bit redundant.
layout (vertices = 2) out;

// first dimension is how many strips you wish to have "clones" of the line essentially, the second is how many subdivisions you want each strip to have
uniform vec2 uLevelOuter;

void main()
{
	// we need to also tell GLSL about the inner level, however lines don't use the inner
	gl_TessLevelOuter[0] = uLevelOuter[0];
	gl_TessLevelOuter[1] = uLevelOuter[1];
}
