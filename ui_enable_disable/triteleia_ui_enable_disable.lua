local pause_btn = Scene.pauseButton
local PAUSE_X = pause_btn.translationX.valueAt(-10000)
local is_enabled = Channel.keyframe().setDefaultEasing("inconst").addKey(-10000,1)

local hud_alpha = Channel.keyframe().addKey(-10000,255)
local hud_translationY = Channel.keyframe().addKey(-10000,0)
local hud_translationX = Channel.keyframe().addKey(-10000,0)
local pause_translationX = Channel.keyframe().addKey(-10000,PAUSE_X)


-- Constants keeping track of how far to move the UI elements until they completely disappear
local PAUSE_MOVEMENT_X = -830
local HUD_MOVEMENT_X = 569
local HUD_MOVEMENT_Y = 333

pause_btn.translationX = pause_translationX

Scene.hud.alpha = hud_alpha
Scene.hud.translationY = hud_translationY
Scene.hud.translationX = hud_translationX

function ui_move_up(timing, end_timing, easing)
	if is_enabled.valueAt(timing) == 1 then	-- If the UI is enabled,
		hud_translationY
		.addKey(timing, hud_translationY.valueAt(timing), easing) -- Retain previous translationY
		.addKey(end_timing, HUD_MOVEMENT_Y) 			 		  -- Move UI up a constant distance 
		
		is_enabled.addKey(timing, 0) -- Log the fact that the UI is now disabled
	end
end

function ui_move_down(timing, end_timing, easing)
	if is_enabled.valueAt(timing) == 0 then -- If the UI is disabled,
		hud_translationY
		.addKey(timing-1, hud_translationY.valueAt(timing-1))
		.addKey(timing, HUD_MOVEMENT_Y, easing)	-- Move UI to the spot it can be moved down from (in case of combining with other disabling modes)
		.addKey(end_timing, 0) 					-- Move UI down a constant distance
						
		hud_translationX
		.addKey(timing-1, hud_translationX.valueAt(timing-1)) -- Retain previous translationX
		.addKey(timing, 0) -- Snap UI to default translationX

		hud_alpha
		.addKey(timing-1, hud_alpha.valueAt(timing-1))
		.addKey(timing, 255)

		pause_translationX
		.addKey(timing-1, pause_translationX.valueAt(timing-1))
		.addKey(timing, PAUSE_X)

		is_enabled.addKey(timing, 1) -- Log the fact that the UI is now enabled
	end
end

function ui_move_sides_out(timing, end_timing, easing)
	if is_enabled.valueAt(timing) == 1 then
		hud_translationX
		.addKey(timing, 0, easing)
		.addKey(end_timing, HUD_MOVEMENT_X)
						
		pause_translationX
		.addKey(timing, pause_translationX.valueAt(timing), easing) -- Since the pause button needs to move left, it needs its own translationX
		.addKey(end_timing, PAUSE_MOVEMENT_X)					    -- that goes opposite the rest of the HUD (it's all on the same canvas)
		
		is_enabled.addKey(timing, 0)
	end
end

function ui_move_sides_in(timing, end_timing, easing)
	if is_enabled.valueAt(timing) == 0 then
		hud_translationX
		.addKey(timing-1, hud_translationX.valueAt(timing-1))
		.addKey(timing, HUD_MOVEMENT_X, easing)
		.addKey(end_timing, 0)
						
		pause_translationX
		.addKey(timing-1, pause_translationX.valueAt(timing-1))
		.addKey(timing, PAUSE_MOVEMENT_X, easing)
		.addKey(end_timing, PAUSE_X)
						
		hud_translationY
		.addKey(timing-1, hud_translationY.valueAt(timing-1))
		.addKey(timing, 0)

		hud_alpha
		.addKey(timing-1, hud_alpha.valueAt(timing-1), easing)
		.addKey(timing, 255)							
						
		is_enabled.addKey(timing, 1)	
	end
end

function ui_fade_out(timing, end_timing, easing)
	if is_enabled.valueAt(timing) == 1 then
		hud_alpha
		.addKey(timing,hud_alpha.valueAt(timing),easing)
		.addKey(end_timing,0)
		
		is_enabled.addKey(timing, 0)
	end
end

function ui_fade_in(timing, end_timing, easing)
	if is_enabled.valueAt(timing) == 0 then
		hud_alpha
		.addKey(timing-1,hud_alpha.valueAt(timing))
		.addKey(timing,0,easing)
		.addKey(end_timing,255)
		
		hud_translationY
		.addKey(timing-1, hud_translationY.valueAt(timing-1))
		.addKey(timing, 0)

		hud_translationX
		.addKey(timing-1,hud_translationX.valueAt(timing-1))
		.addKey(timing, 0)

		pause_translationX
		.addKey(timing-1, pause_translationX.valueAt(timing-1))
		.addKey(timing, pause_translationX.valueAt(0))
		
		is_enabled.addKey(timing, 1)
	end
end

addScenecontrol("disableui", {"end_timing","mode","easing"}, function(cmd)
	local timing = cmd.timing
	local end_timing = cmd.args[1]
	local mode = cmd.args[2] -- up, sides, fadeout
	local easing = cmd.args[3]
	
	if mode == "up" then
		ui_move_up(timing, end_timing, easing)
	elseif mode == "sides" then
		ui_move_sides_out(timing, end_timing, easing)
	else
		ui_fade_out(timing, end_timing, easing)
	end
end)

addScenecontrol("enableui", {"end_timing","mode","easing"}, function(cmd)
	local timing = cmd.timing
	local end_timing = cmd.args[1]
	local mode = cmd.args[2] -- down, sides, fadein
	local easing = cmd.args[3]
	
	if mode == "down" then
		ui_move_down(timing, end_timing, easing)
	elseif mode == "sides" then
		ui_move_sides_in(timing, end_timing, easing)
	else
		ui_fade_in(timing, end_timing, easing)
	end
end)
