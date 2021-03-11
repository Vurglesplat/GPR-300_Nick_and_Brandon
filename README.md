# Project 3 Guide
This project is focused around the exploraation of deferred shading and the g(raphics) buffers utilized to achieve it. As the name says, this proces is used to defer the process of the most intense shading until the program can have it selectively shade what is actually visible. This deferred method can also be used with lighting to a similar effect by only focusing on areas which are actually being directly lit. deteriorate upon being viewed by a camera and bleed out into their surroundings. 

### Opening
 > run LAUNCH_VS.bat , and once visual studio has loaded in simply build and run the program, once it is running, select the file menu -> Load demo... -> Animal3d Demo Plugin

### Contents
Once the animal3d framework is running the program, the controls will be displayed on screen and you can transition between the various passes of different frame buffers and their respective shader effects to see the individual steps with go into bloom, namely:

* Under Render modes: Traditional phon forward shading
  * Which each have render passes to display specific parts of the rendering process
    * And some of the parts will also contain render targets to show specific parts of that rendering pass
* Phong deferred shading
* Phong with a deferred light pass
 
If you accidentally hide the display, typing a capital T will display it again.
