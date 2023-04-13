videobg = Scene.videoBackground
base = Scene.background

bg_alpha_channels = {}
bg_layer_channels = {}
bg_layer_group_channels = {}
bg_sprites = {}
bg_top_layer = videobg.sort.valueAt(0) + 1

-- Replace alpha, layer and sort channels of the video BG (unlike the base BG it's technically a sprite
-- so it has its own layer and sort values that can be controlled easily
bg_alpha_channels["video"] = Channel.keyframe().addKey(0,255)
bg_layer_channels["video"] = Channel.keyframe().setDefaultEasing('inconst').addKey(0,videobg.sort.valueAt(0))
bg_layer_group_channels["video"] = StringChannel.create().addKey(0,videobg.layer.valueAt(0))
videobg.colorA = bg_alpha_channels["video"]
videobg.sort = bg_layer_channels["video"]
videobg.layer = bg_layer_group_channels["video"]

function create_bg (filename)
	if filename ~= nil and filename ~= '' and type(filename) == "string" then
		-- Initializes a new channel for the new BG's alpha values and defaults it to 0
		bg_alpha_channels[filename] = Channel.keyframe().addKey(0,0)
		
		-- Increments the value used to keep track of the topmost BG layer
		bg_top_layer = bg_top_layer + 1
		
		-- Creates a new image from the given filename
		local new_bg = Scene.createSprite(filename, "default", "background")
		
		-- Set a scale that makes it properly match normal BG sizes
		new_bg.scaleX = 160
		new_bg.scaleY = 160
		
		-- Places the new BG on the top of the BG "stack", uses a channel so that the layer and layer group can be easily changed later on
		bg_layer_channels[filename] = Channel.keyframe().setDefaultEasing('inconst').addKey(0,bg_top_layer)
		bg_layer_group_channels[filename] = StringChannel.create().addKey(0,"Background")
		
		new_bg.layer = bg_layer_group_channels[filename]
		new_bg.sort = bg_layer_channels[filename]
		
		-- Makes the new BG use the alpha values given by the previously defined channel
		new_bg.colorA = bg_alpha_channels[filename]
		new_bg.alpha = bg_alpha_channels[filename]
		
		-- Saves the BG sprite pointer for later usage (for bgshow and bgsetlayer)
		bg_sprites[filename] = new_bg
		
		-- Parents the new BG to the base BG for proper scaling with different aspect ratios
		new_bg.setParent(base)
	end
end

function bg_change_opacity(timing, end_timing, filename, alpha, easing)
	if filename ~= nil and filename ~= '' and type(filename) == "string" then
		-- Gets the alpha value of the desired BG at the start timing
		local start_alpha = 0
	
		if filename == "video" then
			start_alpha = videobg.colorA.valueAt(timing)
		else
			start_alpha = bg_sprites[filename].colorA.valueAt(timing)
		end
		
		if timing == 0 and end_timing == 0 then
			bg_alpha_channels[filename].removeKeyAtTiming(0)
			bg_alpha_channels[filename].addKey(0,alpha,easing)
		else
			-- Adds two keys to the alpha value channel associated with the BG
			-- The first key uses the start alpha value and is used to make sure the alpha value of the BG doesn't change
			-- between multiple usages of bgshow on the same BG
			-- The second key is the one that actually changes the BG's alpha to the desired value
			bg_alpha_channels[filename]
			.addKey(timing, start_alpha, easing)
			.addKey(end_timing, alpha)
		end
	end
end

function bg_set_layer(timing, filename, layer, layer_group)
	if filename ~= nil and filename ~= '' and type(filename) == "string" then
		-- Sets the layer of the canvas of the selected BG to the provided layer
		bg_layer_channels[filename].addKey(timing, layer)
		
		if type(layer_group) == "string" and (string.lower(layer_group) == "foreground" or string.lower(layer_group) == "background") then
			if timing == 0 then
				bg_layer_group_channels[filename].removeKeyAtTiming(0)
			end
			
			if string.lower(layer_group) == "foreground" then
				bg_layer_group_channels[filename].addKey(timing, "Foreground")
			else
				bg_layer_group_channels[filename].addKey(timing, "Background")
			end
		end
	end
end

addScenecontrol("bgcreate", {"filename"}, function(cmd)
	local timing = cmd.timing
	local filename = cmd.args[1]
	
	-- You MUST include the file extension
	create_bg(filename)
end)

addScenecontrol("bgshow", {"end_timing","filename","alpha","easing"}, function(cmd)
	local timing = cmd.timing
	local end_timing = cmd.args[1]
	local filename = cmd.args[2]
	local alpha = cmd.args[3]
	local easing = cmd.args[4]
	
	-- Won't work with the base BG 
	bg_change_opacity(timing, end_timing, filename, alpha, easing)
end)

addScenecontrol("bgsetlayer", {"filename","layer","layer_group"}, function(cmd)
	local timing = cmd.timing
	local filename = cmd.args[1]
	local layer = cmd.args[2]
	local layer_group = cmd.args[3] -- Foreground or Background
	
	-- Won't work with the base BG
	bg_set_layer(timing, filename, layer, layer_group)
end)
