## This is intended for use with track tile sizes that match the ones in the original ArcCreate assets (1024x256), for any other sizes you will have to mess with the code on your own. Everything else about it is pretty janky as well because it was originally made for someone else. Have fun.
# Included commands and usage
## scenecontrol(_timing_, makecstrack, _name_, _skinsrc_)
1. _timing_ - not used
2. _name_ - name used to refer to the track in cstrackalpha
3. _skinsrc_ - filename of the track tile image

## scenecontrol(_timing_, cstrackalpha, _name_, _endTiming_, _alpha_, _easing_)
1. _timing_ - start timing for the fading to the target alpha
2. _endTiming_ - end timing for the fading
3. _alpha_ - target alpha value that the track should fade to
4. _easing (optional)_ - easing to use when fading
