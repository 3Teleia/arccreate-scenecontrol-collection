# Included commands and usage
# Mixing different disable and enable modes will work
## scenecontrol(_timing_, disableui, _end_timing, mode, easing_)
1. _timing_ - when the UI should start disappearing
2. _end_timing_ - when the UI should stop disappearing
3. _mode_ - how the UI should disappear. Supported modes are:

      **"up"** - makes the whole UI disappear by moving upwards 
  
      **"sides"** - makes the UI disappear by moving to the sides
  
      **"fadeout"** (default) - makes the UI become fully transparent
  
4. easing (optional) - easing to use when disappearing (both for movement and fading out), linear by default
## scenecontrol(_timing_, enableui, _end_timing, mode, easing_)
1. _timing_ - when the UI should start appearing
2. _end_timing_ - when the UI should stop appearing
3. _mode_ - how the UI should appear. Supported modes are:

      **"down"** - makes the whole UI move in from the top down into its default position
  
      **"sides"** - makes the UI slide in from the sides into its default position
  
      **"fadein"** (default) - makes the UI become fully opaque without moving
  
4. _easing (optional)_ - easing to use when appearing, linear by default
