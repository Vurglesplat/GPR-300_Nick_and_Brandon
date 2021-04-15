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
	
	passTangentBasis_morph_transform_vs4x.glsl
	Calculate and pass morphed tangent basis.
*/

#version 450

#define MAX_OBJECTS 128

// ****DONE: 
//	-> declare morph target attributes
//	-> declare and implement morph target interpolation algorithm
//	-> declare interpolation time/param/keyframe uniform
//	-> perform morph target interpolation using correct attributes
//		(hint: results can be stored in local variables named after the 
//		complete tangent basis attributes provided before any changes)

// signle morph target: position, normal, tangent
//  -> we can have 5 targets: 16 total attribs / 3 per target
//  -> leftover attrib: texcoord

// not morph target: textcoord, bitangent
//  -> tc is common attribute
//  -> bit is cross of nrm and tan

struct sMorphTarget
{
	vec4 position;
	vec4 normal;
	vec4 tangent;
};

layout (location = 0) in sMorphTarget aMorphTarget[5];
layout (location = 15) in vec4 aTexcoord;

struct sModelMatrixStack
{
	mat4 modelMat;						// model matrix (object -> world)
	mat4 modelMatInverse;				// model inverse matrix (world -> object)
	mat4 modelMatInverseTranspose;		// model inverse-transpose matrix (object -> world skewed)
	mat4 modelViewMat;					// model-view matrix (object -> viewer)
	mat4 modelViewMatInverse;			// model-view inverse matrix (viewer -> object)
	mat4 modelViewMatInverseTranspose;	// model-view inverse transpose matrix (object -> viewer skewed)
	mat4 modelViewProjectionMat;		// model-view-projection matrix (object -> clip)
	mat4 atlasMat;						// atlas matrix (texture -> cell)
};

uniform ubTransformStack
{
	sModelMatrixStack uModelMatrixStack[MAX_OBJECTS];
};
uniform int uIndex;

//confirmed to be the keyframe by line 294 of a3_DemoMode4_Animate-idle-render.c
//const a3f32 keyframeTime = (a3f32)demoMode->animMorphTeapot->index + demoMode->animMorphTeapot->param;
uniform float uTime; 

out vbVertexData {
	mat4 vTangentBasis_view;
	vec4 vTexcoord_atlas;
};

flat out int vVertexID;
flat out int vInstanceID;

void main()
{	
	vec4 aPosition;
	vec3 aTangent, aBitangent, aNormal;

	int keyFrameIndex = int(uTime);
	int nextKeyFrameIndex = (keyFrameIndex+1) % 5;
	float param = uTime - floor(uTime);

	aPosition = mix(aMorphTarget[keyFrameIndex].position,aMorphTarget[nextKeyFrameIndex].position,param);
	aTangent = mix(aMorphTarget[keyFrameIndex].tangent,aMorphTarget[nextKeyFrameIndex].tangent,param).xyz;
	aNormal = mix(aMorphTarget[keyFrameIndex].normal,aMorphTarget[nextKeyFrameIndex].normal,param).xyz;
	aBitangent = cross( aNormal, aTangent );

	sModelMatrixStack t = uModelMatrixStack[uIndex];
	
	vTangentBasis_view = t.modelViewMatInverseTranspose * mat4(aTangent, 0.0, aBitangent, 0.0, aNormal, 0.0, vec4(0.0));
	vTangentBasis_view[3] = t.modelViewMat * aPosition;
	gl_Position = t.modelViewProjectionMat * aPosition;
	
	vTexcoord_atlas = t.atlasMat * aTexcoord;

	vVertexID = gl_VertexID;
	vInstanceID = gl_InstanceID;
}
