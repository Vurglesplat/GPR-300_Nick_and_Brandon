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
	
	passColor_interp_tes4x.glsl
	Pass color, outputting result of interpolation.
*/

#version 450

// ****TO-DO: 
//	-> declare uniform block for spline waypoint and handle data
//	-> implement spline interpolation algorithm based on scene object's path
//	-> interpolate along curve using correct inputs and project result

// this shader evaluates one of the subdivided verteces

//ignore this warning if you have it
layout (isolines, equal_spacing) in;

uniform ubCurve
{
	vec4 uCurveWaypoint[32];
	vec4 uCurveTangent[32];
};

uniform int uCount; //so you always know the total

//defined in Curves-dile update 

//32 came from 110 of _Curves files


uniform mat4 uP;

out vec4 vColor;

void main()
{
		// a series of 0-1 values that tell you the type of shape that you are dealing with
	// gl_TessCoord for isolines:
	//	[0] = which line [0, 1]
	//	[1] = subdivision [0,1)
		// in this example:
	// we know that gl_TessCoord[0] = interpolation parameter
	// gl_TessCoord[1] = 0
	
	//indices
	int current = gl_PrimitiveID; // he uses i0
	int destination = (current + 1) % uCount; // he uses i1
	float u = gl_TessCoord[0];


	//vec4 position = vec4(gl_TessCoord[0], 0.0, -1.0, 1.0);
	vec4 position = mix( //he just called this p
		uCurveWaypoint[current],
		uCurveWaypoint[destination],
		u // you can change the color with this var
		);	


	// the projection matrix places it in the scene
	gl_Position = uP * position;
	
	
	vColor = vec4(0.5, 0.5, u, 1.0); //this one also change the color
	
	
	
}
