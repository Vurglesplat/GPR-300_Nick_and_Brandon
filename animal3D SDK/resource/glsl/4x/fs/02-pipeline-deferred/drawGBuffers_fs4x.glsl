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
	
	drawGBuffers_fs4x.glsl
	Output g-buffers for use in future passes.
*/

#version 450

// ****TO-DO:
//	-> declare view-space varyings from vertex shader
//	-> declare MRT for pertinent surface data (incoming attribute info)
//		(hint: at least normal and texcoord are needed)
//	-> declare uniform samplers (at least normal map)
//	-> calculate final normal
//	-> output pertinent surface data

in vec4 vPosition;
in vec4 vNormal;
in vec4 vTexcoord;	
in vec4 vTangent;
in vec4 vBitangent;

//layout (location = 0) out vec4 rtFragColor;
layout (location = 0) out vec4 rtTexcoord;
layout (location = 1) out vec4 rtNormal;
layout (location = 3) out vec4 rtPosition;

uniform sampler2D uTex_nm;
uniform sampler2D uImage00; // diffuse atlas


in vec4 vPosition_screen;

const mat4 bias = mat4 (
 2.0, 0.0, 0.0 , 0.0,
 0.0, 2.0, 0.0 , 0.0,
 0.0, 0.0, 2.0 , 0.0,
 -1.0, -1.0, -1.0, 1.0
);

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE MAGENTA
	//rtFragColor = vec4(1.0, 0.0, 1.0, 1.0);




	mat3 TBN = mat3(normalize(vTangent), normalize(vBitangent), normalize(vNormal));


	vec3 normalTangentSpace = (bias * texture2D(uTex_nm,vTexcoord.xy)).rgb;
    vec3 normalObjectSpace = TBN * normalTangentSpace;
    vec4 normal = vec4(normalObjectSpace,1.0);

//	vec3 nm = texture(uTex_nm, vTexcoord.xy).xyz * 2.0 -vec3(1.0);
//    nm = TBN * normalize(nm);
//	uvec4 outvec0 = uvec4(0);
//	vec4 outvec1 = vec4(0);
//	vec3 color = texture(uImage00, rtTexcoord.xy).rgb;    


//	outvec0.x = packHalf2x16(color.xy);    
//	outvec0.y = packHalf2x16(vec2(color.z, nm.x));
//    outvec0.z = packHalf2x16(nm.yz);
//    outvec0.w = fs_in.material_id;
//    outvec1.xyz = floatBitsToUint(fs_in.ws_coords);
//    outvec1.w = 60.0;
//    color0 = outvec0;
//    color1 = outvec1;


	rtTexcoord = vTexcoord;
	//rtNormal = vec4(( normalize(vNormal.xyz) * 0.5 + 0.5), 1.0); //vec4 is used to make sure that there is always no transparency
	rtNormal = vec4(( normal.xyz * 0.5 + 0.5), 1.0); //vec4 is used to make sure that there is always no transparency
	rtPosition = vPosition_screen / vPosition_screen.w; // dividing by the depth turns the whole image into a box shape
}
