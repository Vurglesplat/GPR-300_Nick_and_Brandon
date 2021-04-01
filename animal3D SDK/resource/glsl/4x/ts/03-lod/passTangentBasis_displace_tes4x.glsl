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
	
	passTangentBasis_displace_tes4x.glsl
	Pass interpolated and displaced tangent basis.
*/

#version 450

// ****TO-DO: 
//	-> declare inbound and outbound varyings to pass along vertex data
//		(hint: inbound matches TCS naming and is still an array)
//		(hint: outbound matches GS/FS naming and is singular)
//	-> copy varying data from input to output
//	-> displace surface along normal using height map, project result
//		(hint: start by testing a "pass-thru" shader that only copies 
//		gl_Position from the previous stage to get the hang of it)

layout (triangles, equal_spacing) in; // not a real error

uniform mat4 uP;

in vbVertexData_tess {
    mat4 vTangentBasis_view;
    vec4 vTexcoord_atlas;
} vVertexData_tess[gl_MaxPatchVertices];

// this is then passed to the lighting shader
out vbVertexData {
    mat4 vTangentBasis_view;
    vec4 vTexcoord_atlas;
} vVertexData;

uniform int uCount;

uniform sampler2D uTex_hm;
uniform float uSize;

void main()
{
	//copy varying data from input to output
    vVertexData.vTangentBasis_view = vVertexData_tess[gl_PrimitiveID].vTangentBasis_view;
    vVertexData.vTexcoord_atlas = vVertexData_tess[gl_PrimitiveID].vTexcoord_atlas;

	// used to determine the positon
	// gl_TessCoord -> barycentric   // represents the co-ordinates of the 

	vVertexData.vTexcoord_atlas = vec4(0);
	vVertexData.vTexcoord_atlas += gl_TessCoord[0] * vVertexData_tess[0].vTexcoord_atlas;
	vVertexData.vTexcoord_atlas += gl_TessCoord[1] * vVertexData_tess[1].vTexcoord_atlas;
	vVertexData.vTexcoord_atlas += gl_TessCoord[2] * vVertexData_tess[2].vTexcoord_atlas;

	vVertexData.vTangentBasis_view = mat4(0);
	vVertexData.vTangentBasis_view += gl_TessCoord[0] * vVertexData_tess[0].vTangentBasis_view;
	vVertexData.vTangentBasis_view += gl_TessCoord[1] * vVertexData_tess[1].vTangentBasis_view;
	vVertexData.vTangentBasis_view += gl_TessCoord[2] * vVertexData_tess[2].vTangentBasis_view;

	vec4 pos = vec4(0);
	pos += gl_TessCoord[0] * gl_in[0].gl_Position;
	pos += gl_TessCoord[1] * gl_in[1].gl_Position;
	pos += gl_TessCoord[2] * gl_in[2].gl_Position;

	pos += uP * normalize(vVertexData.vTangentBasis_view[2]) * texture(uTex_hm, vVertexData.vTexcoord_atlas.xy).r * .1;

	gl_Position = pos;//uP * vVertexData.vTangentBasis_view * vVertexData.vTexcoord_atlas;//vVertexData.vTexcoord_atlas;
}
