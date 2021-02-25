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
	
	drawPhong_shadow_fs4x.glsl
	Output Phong shading with shadow mapping.
*/

#version 450

// ****TO-DO:
// 1) Phong shading
//	-> identical to outcome of last project
// 2) shadow mapping
//	-> declare shadow map texture
//	-> declare shadow coordinate varying
//	-> perform manual "perspective divide" on shadow coordinate
//	-> perform "shadow test" (explained in class)

struct sPointLight
{
	vec4 position;					 //position in rendering target space
	vec4 worldPos;					 //original position in world space
	vec4 color;						 //RGB color with padding
	float radius;						 //radius (distance of effect from center)
	float radiusSq;					 //radius squared (if needed)
	float radiusInv;					 //radius inverse (attenuation factor)
	float radiusInvSq;					 //radius inverse squared (attenuation factor)
};

uniform ubLight
{
	sPointLight uPointLightData[4]; //found at line 108 of PostProc.h
};

uniform sampler2D uTex_dm;
uniform vec4 uColor; 


layout (location = 0) out vec4 rtFragColor;

in vec4 vNormal;
in vec4 vPosition;
in vec2 vTexCoord; 

void main()
{
	vec4 tex = texture(uTex_dm, vTexCoord); 

	vec4 N = normalize(vNormal);
	vec4 L = uPointLightData[1].position - vPosition;
	float lightDistance = length(L);
	L = L/lightDistance; //This normalizes L WITHOUT using the normalize function
						 // which would have called length() again, and we are using it later for attenuation

	float lmbCoeff = max(0.0,dot(N, L));
	float attenuation = mix(1.0,0.0,lightDistance * uPointLightData[1].radiusInvSq); // light intensity is based on distance relative to radius
	
	//Determining view and reflection vectors;
	//thence the phong coefficient
	vec4 V = normalize(-vPosition);
	vec4 R = reflect(-L,N);
	float phongCoeff = max(0.0,dot(R, V));

	vec4 result = tex * uColor * uPointLightData[1].color * (lmbCoeff + phongCoeff) * attenuation;
	rtFragColor = vec4(result.rgb,1.0); 


//rtFragColor = texture(uTex_dm,vTexCoord);
}
