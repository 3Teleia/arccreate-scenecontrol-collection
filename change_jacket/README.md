# Included commands and usage
## scenecontrol(_timing_, createjacket, _filename_, _size\_px_)
1. _timing_ - not used internally, can be left as 0 (can be used to change the initial ordering of the created images by setting different timings)
2. _filename_ - full name of the image that you want to use, including its file extension (e.g., "newjacket.jpg")
3. _size\_px (optional)_ - width and height of the source image, defaults to 512

**You do not have to use createjacket if you are using standard 512x512 jacket images - you can use them directly in changetojacket, which will automatically create the jacket for you and assume it is 512x512.**

## scenecontrol(_timing_, changetojacket, _end_timing_, _filename_, _easing_)
1. _timing_ - when to start fading in the new jacket
2. _end_timing_ - when to stop fading in the new jacket
3. _filename_ - full name of the image that you want to use, including its file extension (e.g., "newjacket.jpg")
4. _easing (optional)_ - easing to use when fading to full opacity, defaults to "l"
