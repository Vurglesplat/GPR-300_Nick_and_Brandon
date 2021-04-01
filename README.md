# Project 4 Guide

### Opening
 > run LAUNCH_VS.bat , and once visual studio has loaded in simply build and run the program, once it is running, select the file menu -> Load demo... -> Animal3d Demo Plugin

### Contents
Once the animal3d framework is running the program, the controls will be displayed on screen and you can transition between the various passes of different frame buffers and their respective shader effects to see the individual steps with go into bloom, namely:

* Pressing j and k switches between the various algorithms associated with normals and heightmaps for the objects in the scene
  * parallax occlusion uses height maps to simulate a more complicated surface for shapes
  * and level-of-detail actually displaces the subdivided sections of the primitives and morphs based off the height map
* F toggles a wireframe display on the primitives
* B toggles a display which shows a tiny set of three lines on every vertex (and in the center of the planes formed by these vertexes) which display its normal, tangent and bitangent.


If you accidentally hide the display, typing a capital T will display it again.
