# Project 2 Guide
This project is focused around the implementation of frame buffers and how they can be utilized to interact with each other to produce post processing effects. In this project we will look specifically at bloom  - the phenomenon where bright lights deteriorate upon being viewed by a camera and bleed out into their surroundings. 

### Opening
 > run LAUNCH_VS.bat , and once visual studio has loaded in simply build and run the program, once it is running, select the file menu -> Load demo... -> Animal3d Demo Plugin

### Contents
Once the animal3d framework is running the program, the controls will be displayed on screen and you can transition between the various passes of different frame buffers and their respective shader effects to see the individual steps with go into bloom, namely:

* Scene - The original scene
* Bright passes - called several times, they are used to obtain the brightest and darkest sections of each image
* Blur passes - also called several times, each time it is called it takes either horizontal or vertical pixels and begins to blur them together, this is used to spread out the lighting from the bright passes in a similar manner to how light diffuses
* Composite - the final pass, which merges the previous passes into one cohesive image that simulates bloom.
 
If you accidentally hide the display, typing a capital T will display it again.
