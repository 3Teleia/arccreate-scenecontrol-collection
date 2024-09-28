local tracks = {}
local track_alpha_channels = {}
local track_layer_channels = {}
local track_texture_channels = {}
local top_layer = Scene.track.sort.valueAt(0) + 1 -- Allow placement of newly skinned tracks above the default one
local current_skin = StringChannel.create().addKey(0,"base") -- Saves names of when which track skins were used

-- Assuming the 0ms timing in the base group is the base BPM
-- Used for the track scrolling texture offset
local current_bpm = Context.bpm(0)
local base_bpm = current_bpm.valueAt(0)

function change_track_skin(timing, end_timing, skin, easing)
	if skin ~= nil and skin ~= '' and type(skin) == "string" then
		skin = string.lower(skin) -- Ensure case insensitivity
		
		if skin == current_skin.valueAt(timing) then return end -- Ignore attempts to use the same skin multiple times in a row
		
		if skin == "base" then -- If returning to the base skin of the track, hide the current custom skinned track
			track_alpha_channels[current_skin.valueAt(timing)].addKey(timing,255).addKey(end_timing,0)
			track_layer_channels[current_skin.valueAt(timing)].addKey(end_timing,top_layer-2)
		
		elseif tracks[skin] ~= nil then -- If track with desired skin already exists,
			local start_alpha = track_alpha_channels[skin].valueAt(timing)

			track_alpha_channels[skin]
			.addKey(timing,start_alpha,easing)
			.addKey(end_timing,255)
			
			if current_skin.valueAt(timing) ~= "base" then
				track_alpha_channels[current_skin.valueAt(timing)].addKey(end_timing,0,"inconst")
				track_layer_channels[current_skin.valueAt(timing)].addKey(end_timing,top_layer-2) -- Put last used skin track below the new track when the new track is FINISHED fading in
			end
			
			track_layer_channels[skin]
			.addKey(timing,top_layer+1)    -- Put new track on the very top
			.addKey(end_timing, top_layer) -- Put new track 1 layer below the topmost layer so that other tracks can go above it later

		else 									  -- If track with desired skin does not exist,
			tracks[skin] = Scene.track.copy(true) -- Create a copy of the main track
			tracks[skin].setTrackSprite(skin)     -- Change its skin to the specified skin
			
			track_alpha_channels[skin] = 
			Channel.keyframe()				-- Create an exclusive alpha channel for the new track
			.addKey(-10000,0)				-- Make track start fully transparent
			.addKey(timing,0,easing)		-- Ensure track stays transparent until it's go time
			.addKey(end_timing,255,easing)  -- Fade new track into existence			
			
			-- Make the new track use the above channel for its alpha values
			tracks[skin].colorA = track_alpha_channels[skin]
			
			local track_divide_lines = {tracks[skin].divideLine12, tracks[skin].divideLine23, tracks[skin].divideLine34}
			local track_critical_lines = {tracks[skin].criticalLine1, tracks[skin].criticalLine2, tracks[skin].criticalLine3, tracks[skin].criticalLine4}
			for _, line in ipairs(track_divide_lines) do
				line.colorA = tracks[skin].colorA
				line.alpha = tracks[skin].colorA
			end
			for _, line in ipairs(track_critical_lines) do
				line.colorA = tracks[skin].colorA
				line.alpha = tracks[skin].colorA
			end
			
			if current_skin.valueAt(timing) ~= "base" then 										-- If this isn't the first skin change,
				track_layer_channels[current_skin.valueAt(timing)].addKey(end_timing,top_layer-2)	-- Put last used skin track below the new track when the new track is FINISHED fading in
			end
			
			track_layer_channels[skin] = 
			Channel.keyframe().setDefaultEasing('inconst')  -- Create a channel that determines the layer of the new track
			.addKey(-10000,top_layer-2)    					-- Place it below the main track
			.addKey(timing, top_layer+1)   					-- Put new track on the top when it starts fading in
			.addKey(end_timing, top_layer) 					-- Put new track 1 layer below the topmost layer
			tracks[skin].sort = track_layer_channels[skin]  -- Make the new track use the above channel for its layering
			
			-- The base track does not use textureOffsetY, that cannot be reused here
			-- track_texture_channels[skin] = Channel.keyframe().addKey(0,0).addKey(1000000,6000) * (current_bpm / base_bpm)
			track_texture_channels[skin] = Channel.saw("l", 10000000, 0, 57800, 0) * (current_bpm / base_bpm)
			tracks[skin].textureOffsetY = track_texture_channels[skin] -- ensure the track still looks like it's scrolling
		end
		
		current_skin.addKey(end_timing,skin) -- Save the fact that this was the newest used track in the skin timeline
	end
end

addScenecontrol("changetrackskin", {"end_timing","skin","easing"}, function(cmd)
	local timing = cmd.timing
	local end_timing = cmd.args[1]
	local skin = cmd.args[2] -- Case insensitive, name of the desired track skin within the Skin window
	local easing = cmd.args[3]
	
	change_track_skin(timing, end_timing, skin, easing)
end)

-- trackdisplay but it affects the current custom track
function track_skin_display(timing, end_timing, alpha, easing)
    local track_alpha = track_alpha_channels[current_skin.valueAt(timing)]

    track_alpha
	.addKey(timing, track_alpha.valueAt(timing), easing)
    .addKey(end_timing, alpha)
end

addScenecontrol("trackskindisplay", {"end_timing","alpha","easing"}, function(cmd)
	local timing = cmd.timing
	local end_timing = cmd.args[1]
	local alpha = cmd.args[2]
	local easing = cmd.args[3]
	
	track_skin_display(timing, end_timing, alpha, easing)
end)
