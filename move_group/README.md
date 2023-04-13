## Like with camera commands, commands for movement along different axes can be written separately, e.g. to start and finish at different times or to use different easings
# Included commands and usage

The movement applies to the timinggroup the command is in, like hidegroup.

x = left and right, y = up and down, z = forwards and backwards (relative to the default camera)

## scenecontrol(_timing_, movenotegroup, _end_timing_, _x_, _y_, _z_, _easing_)
1. _timing_ - when the notes should start moving
2. _end_timing_ - when the notes should stop moving
3. _x, y, z_ - to which coordinate on each respective axis the group should be moved, any can be left as 0
4. _easing (optional)_ - easing to use when moving the note group, applies to all axes in the command

## scenecontrol(_timing_, movenotegroupdelta, _end_timing_, _dx_, _dy_, _dz_, _easing_)
1. _timing_ - when the notes should start moving
2. _end_timing_ - when the notes should stop moving
3. _dx, dy, dz_ - by how much the note group should be moved along each respective axis, any can be left as 0
4. _easing (optional)_ - easing to use when moving the note group, applies to all axes in the command
