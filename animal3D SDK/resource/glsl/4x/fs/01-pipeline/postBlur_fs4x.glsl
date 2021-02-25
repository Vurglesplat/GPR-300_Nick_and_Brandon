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

// ****TO-DO:
//	-> declare texture coordinate varying and input texture
//	-> declare sampling axis uniform (see render code for clue)
//	-> declare Gaussian blur function that samples along one axis
//		(hint: the efficiency of this is described in class)

in vec4  vTexcoord_atlas;
uniform sampler2D uTex_dm;
uniform vec2 uAxis;

layout (location = 0) out vec4 rtFragColor;

void main()
{

//
//
//vec4 c = vec4(0.0);
//ivec2 P = ivec2(gl_FragCoord.xy) - ivec2(0, weights.length() >> 1);
//int i;
//for (i = 0; i < weights.length(); i++)    
//{        
//	c += texelFetch(uTex_dm, P + ivec2(0, i), 0) * weights[i];
//}
//    rtFragColor = c;

	// DUMMY OUTPUT: all fragments are OPAQUE AQUA
	rtFragColor = vec4(1.0, 0.0, 1.0, 1.0);
	vec2 temp = {0.5, 0.5};

	vec4 finalColor =  texture(uTex_dm, vTexcoord_atlas.xy);
	finalColor += texture(uTex_dm, vec2(vTexcoord_atlas.x + uAxis.x,vTexcoord_atlas.y + uAxis.y));
	finalColor += texture(uTex_dm, vec2(vTexcoord_atlas.x - uAxis.x,vTexcoord_atlas.y - uAxis.y));
	rtFragColor = finalColor/3.0f;	

//	rtFragColor = texture(uTex_dm, vTexcoord_atlas.xy);	


////	if(vTexCoord.x < temp.x)
////		rtFragColor = vec4(1.0, 0.0, 1.0, 1.0);
////	else
//
////vec2 currentCoord = vTexcoord;
//	
//	  //       e.g. horizontal: vec2(1/img_width, 0)
//		//	   e.g. vertical: vec2(0, 1/img_height)

}
