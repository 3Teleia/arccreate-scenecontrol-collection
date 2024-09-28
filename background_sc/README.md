# Included commands and usage
## scenecontrol(_timing_, bgcreate, _filename_, _width\_px_, _height\_px_)
1. _timing_ - not used internally, can be left as 0 (can be used to change the initial ordering of the created images by setting different timings)
2. _filename_ - full name of the image that you want to use, including its file extension (e.g., "base_conflict.jpg")
3. _width\_px (optional)_ - width of the source image, defaults to 1280
4. _height\_px (optional)_ - height of the source image, defaults to 960

**You do not have to use this to use any of the other events if your image is the usual 1280x960 resolution, using any other command automatically creates the BG with the default sizing. These commands use the filename used in the bgcreate command as an identifier of which background image should be modified.**

Newly bgcreated BGs have an alpha value of 0.

Works both with .jpg and .png files. **The files have to be within the Scenecontrol folder of the chart.**
## scenecontrol(_timing_, bgshow, _end_timing_, _filename_, _alpha_, _easing_)
1. _timing_ - when the background should start easing into its new alpha value
2. _end_timing_ - when the background should reach the specified alpha value
3. _filename_ - identifying filename of an already existing background
4. _alpha_ - end alpha value of the background
5. _easing (optional)_ - linear by default

Use "video" to change the video background's alpha value.
## scenecontrol(_timing_, bgsetlayer, _filename_, _layer_, _layer_group_)
1. _timing_ - when the layer of the background should be changed
2. _filename_ - identifying filename of an already existing background
3. _layer_ - integer that determines the layer within which the background should be placed. Higher values are visible first
4. _layer_group_ (optional) - determines which of layer group the image should be placed in - **foreground**, **UI**, or **background** (case-insensitive, any other values will make the BG stay in the same group it was in previously)

In "Foreground" layers will be placed and be visible 'above' the track, **.png images with transparent areas that are moved to this group should also work properly and show what is "behind" those areas**. In "Background" layers will be placed 'below' the track. Every background is in "Background" by default. "UI" is a little weird but should be above "Foreground".

You cannot change the base background's layering, but you can change the layering of the video background by using "video" as the filename, for example, in bgshow
