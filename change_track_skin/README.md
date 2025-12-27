# Included commands and usage
## scenecontrol(_timing_, changetrackskin, _end_timing_, _skin_, _easing_)
1. _timing_ - when the track should start fading into the new skin
2. _end_timing_ - when the track should finish fading into the new skin
3. _skin_ - case-insensitive, any valid name **from the project's Skin section's Track list** (e.g., "rei", "TEMPESTISSIMO", "Colorless"). [There are a few exceptions as can be seen here](https://github.com/Arcthesia/ArcCreate/tree/trunk/Assets/Textures/Gameplay/Track) - "Light" from the track list should be "white", "DarkVs" should be "conflictvs"
4. _easing (optional)_ - easing to use when fading into the new track skin, linear by default
