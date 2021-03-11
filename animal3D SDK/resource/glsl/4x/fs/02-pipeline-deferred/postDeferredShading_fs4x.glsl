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
	
	postDeferredShading_fs4x.glsl
	Calculate full-screen deferred Phong shading.
*/

#version 450

#define MAX_LIGHTS 1024

// ****TO-DO:
//	-> this one is pretty similar to the forward shading algorithm (Phong NM) 
//		except it happens on a plane, given images of the scene's geometric 
//		data (the "g-buffers"); all of the information about the scene comes 
//		from screen-sized textures, so use the texcoord varying as the UV
//	-> declare point light data structure and uniform block
//	-> declare pertinent samplers with geometry data ("g-buffers")
//	-> use screen-space coord (the inbound UV) to sample g-buffers
//	-> calculate view-space fragment position using depth sample
//		(hint: modify screen-space coord, use appropriate matrix to get it 
//		back to view-space, perspective divide)
//	-> calculate and accumulate final diffuse and specular shading

in vec4 vTexcoord_atlas;


uniform sampler2D uImage00; // diffuse atlas
uniform sampler2D uImage01; // specular atlas


uniform sampler2D uImage04; // scene texcoord
uniform sampler2D uImage05; // scene normal
//uniform sampler2D uImage06; // scene postion
uniform sampler2D uImage07; // scene depth

//from render
uniform int renderModeLightCount;
uniform mat4 uPB_inv;	
uniform int uCount;

layout (location = 0) out vec4 rtFragColor;


// from the forward shading version

struct sPointLightData
{
    vec4 position;                    // position in rendering target space
    vec4 worldPos;                    // original position in world space
    vec4 color;                        // RGB color with padding
    float radius;                        // radius (distance of effect from center)
    float radiusSq;                    // radius squared (if needed)
    float radiusInv;                    // radius inverse (attenuation factor)
    float radiusInvSq;                    // radius inverse squared (attenuation factor)
};

uniform ubo_light
{
    sPointLightData uPointLightData[MAX_LIGHTS];
};



void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE ORANGE
	//	rtFragColor = vec4(1.0, 0.5, 0.0, 1.0);
	

	// phong
	// ambient
	// diffuse color * diffuse light +  specular color + specular light
	
	// we have: diff&spec atlas, light data -> uniform
	// we need: , model/scene data -> g-buffers 


	// draw objects with the diffuse texture applied
		// use screenspace coords to sample from the scene texcoord
	//
	vec4 sceneTexcoord = texture(uImage04, vTexcoord_atlas.xy); 
	vec4 diffuseSample = texture(uImage00, sceneTexcoord.xy);
	vec4 specularSample = texture(uImage01, sceneTexcoord.xy);

	vec4 position_screen = vTexcoord_atlas;
	position_screen.z = texture(uImage07, vTexcoord_atlas.xy).r;

	vec4 position_view = uPB_inv * position_screen;
	position_view /= position_view.w;
	vec4 normal_view = texture(uImage05, vTexcoord_atlas.xy);
	normal_view = (normal_view - 0.5) * 2.0;

	rtFragColor = normal_view;
	rtFragColor.a = diffuseSample.a; //allows it to not affect the skybox



							// from the forward phong implementation
	vec4 tex = texture(uImage05, vTexcoord_atlas.xy); 

	//phong shading
	vec4 effect = vec4(0.0);
	for(int i = 0; i < uCount; i++)
	{

		vec4 N = normalize(texture(uImage05, vTexcoord_atlas.xy));
		vec4 L = uPointLightData[i].position - vTexcoord_atlas;
		float lightDistance = length(L);
		L = L/lightDistance; //This normalizes L WITHOUT using the normalize function
							 // which would have called length() again, and we are using it later for attenuation
	
		float lmbCoeff = max(0.0,dot(N, L));
		float attenuation = mix(1.0,0.0,lightDistance * uPointLightData[i].radiusInvSq); // light intensity is based on distance relative to radius
		
		//Determining view and reflection vectors;
		//thence the phong coefficient
		vec4 V = normalize(-vTexcoord_atlas);
		vec4 R = reflect(-L,N);
		float phongCoeff = max(0.0,dot(R, V));


		//shadow mapping scales down
//		lmbCoeff *= fragIsShadowed * 0.2 + (1-fragIsShadowed) * 1.0;

		effect += uPointLightData[i].color * (lmbCoeff + phongCoeff) * attenuation;
	}
	vec4 result = tex * texture(uImage05, vTexcoord_atlas.xy);// * effect;
	//rtFragColor = vec4(texture(uImage05, vTexcoord_atlas.xy).rbg,1.0); 
	rtFragColor = result; 
}
