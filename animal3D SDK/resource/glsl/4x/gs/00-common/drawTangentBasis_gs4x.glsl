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
	
	drawTangentBases_gs4x.glsl
	Draw tangent bases of vertices and/or faces, and/or wireframe shapes, 
		determined by flag passed to program.
*/

#version 450

// ****TO-DO: 
//	-> declare varying data to read from vertex shader
//		(hint: it's an array this time, one per vertex in primitive)
//	-> use vertex data to generate lines that highlight the input triangle
//		-> wireframe: one at each corner, then one more at the first corner to close the loop
//		-> vertex tangents: for each corner, new vertex at corner and another extending away 
//			from it in the direction of each basis (tangent, bitangent, normal)
//		-> face tangents: ditto but at the center of the face; need to calculate new bases
//	-> call "EmitVertex" whenever you're done with a vertex
//		(hint: every vertex needs gl_Position set)
//	-> call "EndPrimitive" to finish a new line and restart
//	-> experiment with different geometry effects

// (2 verts/axis * 3 axes/basis * (3 vertex bases + 1 face basis) + 4 to 8 wireframe verts = 28 to 32 verts)
#define MAX_VERTICES 32

layout (triangles) in;

layout (line_strip, max_vertices = MAX_VERTICES) out;

in vbVertexData {
	mat4 vTangentBasis_view;
	vec4 vTexcoord_atlas;
} vVertexData[];

uniform vec4[] uColor0; // default colors from the cpu
uniform float uSize;	// length of the tangent lines
uniform int uFlag;      
uniform mat4 uMVP;

out vec4 vColor;

void drawWireFrame()
{

	vColor = uColor0[5];
	gl_Position = uMVP *gl_in[0].gl_Position;
	EmitVertex();
	gl_Position = uMVP *gl_in[1].gl_Position;
	EmitVertex();
	EndPrimitive(); // this brings the solid edges after a sequence of verteces

	vColor = uColor0[5];
	gl_Position = uMVP *gl_in[1].gl_Position;
	EmitVertex();
	gl_Position = uMVP *gl_in[2].gl_Position;
	EmitVertex();
	EndPrimitive(); 


	vColor = uColor0[5];
	gl_Position = uMVP *gl_in[2].gl_Position;
	EmitVertex();
	gl_Position = uMVP *gl_in[0].gl_Position;
	EmitVertex();
	EndPrimitive(); 
}

void drawFaceTangents()
{	
	vec4 tan_view = normalize(vVertexData[gl_InvocationID].vTangentBasis_view[0]);
	vec4 bit_view = normalize(vVertexData[gl_InvocationID].vTangentBasis_view[1]);
	vec4 nrm_view = normalize(vVertexData[gl_InvocationID].vTangentBasis_view[2]);


	vec3 DeltaP1 = gl_in[1].gl_Position.xyz - gl_in[0].gl_Position.xyz;
	vec3 DeltaP2 = gl_in[2].gl_Position.xyz - gl_in[0].gl_Position.xyz;
	vec3 faceNormal = normalize(cross(DeltaP2,DeltaP1));
	vec4 faceCenter = (gl_in[0].gl_Position + gl_in[1].gl_Position + gl_in[2].gl_Position) / 3.0;

	vColor = uColor0[16];
	gl_Position = uMVP * faceCenter;
	EmitVertex();
	gl_Position = uMVP * (faceCenter + vec4(faceNormal * uSize * 3.0, 0.0) );
	EmitVertex();
	EndPrimitive();
	
	mat2x3 P1P2 = mat2x3(DeltaP1.x, DeltaP2.x,
						 DeltaP1.y, DeltaP2.y,
						 DeltaP1.z, DeltaP2.z);
	
	vec2 DeltaUV1 = gl_in[1].gl_Position.xy - gl_in[0].gl_Position.xy;
	vec2 DeltaUV2 = gl_in[2].gl_Position.xy - gl_in[0].gl_Position.xy;

	mat2 UV1UV2 = mat2  (DeltaUV1.x, DeltaUV2.x,
						 DeltaUV1.y, DeltaUV2.y);

	mat2x3 Tangent_Bitan = P1P2  * inverse(UV1UV2);

	vColor = uColor0[8];
	gl_Position = uMVP * faceCenter;
	EmitVertex();
	gl_Position = uMVP * (faceCenter + vec4(/*Tangent_Bitan[0]*/ tan_view.xyz * uSize * 3.0, 0.0) );
	EmitVertex();
	EndPrimitive();

	vColor = uColor0[0];
	gl_Position = uMVP * faceCenter;
	EmitVertex();
	gl_Position = uMVP * (faceCenter + vec4(/*Tangent_Bitan[1]*/ bit_view.xyz * uSize * 3.0, 0.0) );
	EmitVertex();
	EndPrimitive();



}

void drawVertexTangents()
{
	vec4 tan_view = normalize(vVertexData[gl_InvocationID].vTangentBasis_view[0]);
	vec4 bit_view = normalize(vVertexData[gl_InvocationID].vTangentBasis_view[1]);
	vec4 nrm_view = normalize(vVertexData[gl_InvocationID].vTangentBasis_view[2]);

			// draw tangents off of each point
	vec4 offset = vec4(uSize, 0.0, 0.0, 1.0);
	vColor = uColor0[8];
	gl_Position = uMVP * gl_in[0].gl_Position;
	EmitVertex();
	gl_Position = (uMVP *  gl_in[0].gl_Position + (tan_view) );
	EmitVertex();
	EndPrimitive();

	offset = vec4(0.0, uSize, 0.0, 0.0);
	vColor = uColor0[0];
	gl_Position = uMVP * gl_in[0].gl_Position;
	EmitVertex();
	gl_Position = (uMVP *  gl_in[0].gl_Position + (bit_view )  );
	EmitVertex();
	EndPrimitive();

	offset = vec4(0.0, 0.0, uSize, 0.0);
	vColor = uColor0[16];
	gl_Position = uMVP * gl_in[0].gl_Position;
	EmitVertex();
	gl_Position = ( uMVP * gl_in[0].gl_Position + (nrm_view) );
	EmitVertex();
	EndPrimitive();


	offset = vec4(uSize, 0.0, 0.0, 1.0);
	vColor = uColor0[8];
	gl_Position = uMVP * gl_in[1].gl_Position;
	EmitVertex();
	gl_Position = (uMVP *  gl_in[1].gl_Position + (tan_view) );
	EmitVertex();
	EndPrimitive();

	offset = vec4(0.0, uSize, 0.0, 0.0);
	vColor = uColor0[0];
	gl_Position = uMVP * gl_in[1].gl_Position;
	EmitVertex();
	gl_Position = (uMVP *  gl_in[1].gl_Position + (bit_view )  );
	EmitVertex();
	EndPrimitive();

	offset = vec4(0.0, 0.0, uSize, 0.0);
	vColor = uColor0[16];
	gl_Position = uMVP * gl_in[1].gl_Position;
	EmitVertex();
	gl_Position = ( uMVP * gl_in[1].gl_Position + (nrm_view) );
	EmitVertex();
	EndPrimitive();


    offset = vec4(uSize, 0.0, 0.0, 1.0);
	vColor = uColor0[8];
	gl_Position = uMVP * gl_in[2].gl_Position;
	EmitVertex();
	gl_Position = (uMVP *  gl_in[2].gl_Position + (tan_view) );
	EmitVertex();
	EndPrimitive();

	offset = vec4(0.0, uSize, 0.0, 0.0);
	vColor = uColor0[0];
	gl_Position = uMVP * gl_in[2].gl_Position;
	EmitVertex();
	gl_Position = (uMVP *  gl_in[2].gl_Position + (bit_view )  );
	EmitVertex();
	EndPrimitive();

	offset = vec4(0.0, 0.0, uSize, 0.0);
	vColor = uColor0[16];
	gl_Position = uMVP * gl_in[2].gl_Position;
	EmitVertex();
	gl_Position = ( uMVP * gl_in[2].gl_Position + (nrm_view) );
	EmitVertex();
	EndPrimitive();
}

void main()
{
	if (uFlag >= 4)
		drawWireFrame();
	if (uFlag == 7 || uFlag == 3)
	{
		drawFaceTangents();
		drawVertexTangents();
	}
}
