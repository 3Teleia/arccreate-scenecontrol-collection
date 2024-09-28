-- Backgrounds tend to be 1280x960, but some tend to be larger which should be taken into account
local DEFAULT_WIDTH = 1280
local DEFAULT_HEIGHT = 960

local VALID_LAYER_GROUPS = {}
VALID_LAYER_GROUPS["foreground"] = 1
VALID_LAYER_GROUPS["background"] = 1
VALID_LAYER_GROUPS["ui"] = 1 -- no, this doesnt put it above the info panel and stuff, you'll need to reparent for that

videobg = Scene.videoBackground
base = Scene.background

bg_alpha_channels = {}
bg_layer_channels = {}
bg_layer_group_channels = {}
bg_sprites = {}
bg_top_layer = videobg.sort.valueAt(0) + 1

-- Replace alpha, layer and sort channels of the video BG (unlike the base BG it's technically a sprite
-- so it has its own layer and sort values that can be controlled easily
bg_alpha_channels["video"] = Channel.keyframe().addKey(-10000,255)
bg_layer_channels["video"] = Channel.keyframe().setDefaultEasing('inconst').addKey(-10000,videobg.sort.valueAt(0))
bg_layer_group_channels["video"] = StringChannel.create().addKey(-10000,videobg.layer.valueAt(0))
videobg.colorA = bg_alpha_channels["video"]
videobg.sort = bg_layer_channels["video"]
videobg.layer = bg_layer_group_channels["video"]

function create_bg(filename, width, height)
	-- Using default values if necessary
	if width == nil or width == 0 then
		width = DEFAULT_WIDTH
	end
	if height == nil or height == 0 then
		height = DEFAULT_HEIGHT
	end

	-- Ignoring attempts to make the same BG instance
	if bg_sprites[filename] then return end

	if filename ~= nil and filename ~= '' and type(filename) == "string" then
		-- Initializes a new channel for the new BG's alpha values and defaults it to 0
		bg_alpha_channels[filename] = Channel.keyframe().addKey(-10000,0)
		
		-- Increments the value used to keep track of the topmost BG layer
		bg_top_layer = bg_top_layer + 1
		
		-- Creates a new image from the given filename
		local new_bg = Scene.createSprite(filename, "default", "background")
		
		-- Set a scale that makes it properly match the BG size for that image size
		new_bg.scaleX = 160 * DEFAULT_WIDTH/width
		new_bg.scaleY = 160 * DEFAULT_HEIGHT/height
		
		-- Places the new BG on the top of the BG "stack", uses a channel so that the layer and layer group can be easily changed later on
		bg_layer_channels[filename] = Channel.keyframe().setDefaultEasing('inconst').addKey(-10000,bg_top_layer)
		bg_layer_group_channels[filename] = StringChannel.create().addKey(-10000,"Background")
		
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
	-- Force attempt to create bg with default sizing in case the BG doesn't exist at the required timing
	create_bg(filename)

	if filename ~= nil and filename ~= '' and type(filename) == "string" then
		-- Gets the alpha value of the desired BG at the start timing
		local start_alpha = bg_alpha_channels[filename].valueAt(timing)		
		
		-- Adds two keys to the alpha value channel associated with the BG
		-- The first key uses the start alpha value and is used to make sure the alpha value of the BG doesn't change
		-- between multiple usages of bgshow on the same BG
		-- The second key is the one that actually changes the BG's alpha to the desired value
		bg_alpha_channels[filename]
		.addKey(timing, start_alpha, easing)
		.addKey(end_timing, alpha)
	end
end

function bg_set_layer(timing, filename, layer, layer_group)
	-- Force attempt to create bg with default sizing in case the BG doesn't exist at the required timing
	create_bg(filename)
	
	-- Deal with people typing it incorrectly for easier checking down the line
	if layer_group and type(layer_group) == "string" then 
		layer_group = string.lower(layer_group) 
	end

	if filename ~= nil and filename ~= '' and type(filename) == "string" then
		-- Sets the layer of the canvas of the selected BG to the provided layer
		bg_layer_channels[filename].addKey(timing, layer)
		
		if VALID_LAYER_GROUPS[layer_group] then		
			if layer_group == "foreground" then
				bg_layer_group_channels[filename].addKey(timing, "Foreground")
			elseif layer_group == "ui" then
				bg_layer_group_channels[filename].addKey(timing, "UI")
			else
				bg_layer_group_channels[filename].addKey(timing, "Background")
			end
		end
	end
end

addScenecontrol("bgcreate", {"filename","width_px","height_px"}, function(cmd)
	local filename = cmd.args[1]
	local width = cmd.args[2]
	local height = cmd.args[3]
	
	-- You MUST include the file extension
	create_bg(filename,width,height)
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
