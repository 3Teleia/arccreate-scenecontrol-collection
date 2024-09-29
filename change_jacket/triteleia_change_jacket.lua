local DEFAULT_SIZE = 512

jackets = {}
jacket_alpha_channels = {}
jacket_sort_channels = {}
current_jacket = StringChannel.create().addKey(-10000,"base")

function create_jacket(filename, size) 
    if jackets[filename] then return end

    if size == nil or size == 0 then
		size = DEFAULT_SIZE
	end

	if filename ~= nil and filename ~= '' and type(filename) == "string" then
        jacket_alpha_channels[filename] = Channel.keyframe().addKey(-10000,0)
        jacket_sort_channels[filename] = Channel.keyframe().setDefaultEasing("inconst").addKey(-10000,10)

        local new_jacket = Scene.createSprite(filename, "default", "notes", xy(0,0))
        new_jacket.setParent(Scene.jacket)
        new_jacket.layer = "Topmost"
        new_jacket.active = Channel.condition(jacket_alpha_channels[filename], 0, 1, 0, 0) -- disable at 0 alpha
        new_jacket.scaleX = 39.3 * DEFAULT_SIZE/size
        new_jacket.scaleY = 39.3 * DEFAULT_SIZE/size
        new_jacket.translationX = 0
        new_jacket.translationY = 0
        new_jacket.sort = jacket_sort_channels[filename]

        new_jacket.colorA = jacket_alpha_channels[filename]
        new_jacket.alpha = jacket_alpha_channels[filename]

        jackets[filename] = new_jacket
    end
end

function change_jacket(timing, end_timing, filename, easing)
    create_jacket(filename)

    if filename ~= nil and filename ~= '' and type(filename) == "string" then
        local old_jacket = current_jacket.valueAt(timing)

        if old_jacket == filename then return end -- ignore changing to same jacket

        if old_jacket ~= "base" then
            jacket_sort_channels[old_jacket].addKey(timing, 0)

            jacket_alpha_channels[old_jacket]
            .addKey(timing, jacket_alpha_channels[old_jacket].valueAt(timing), "inconst")
            .addKey(end_timing, 0)
        end
        
        jacket_sort_channels[filename].addKey(timing,20)

        jacket_alpha_channels[filename]
        .addKey(timing, jacket_alpha_channels[filename].valueAt(timing), easing)
        .addKey(end_timing, 255)

        current_jacket.addKey(timing, filename)
    end
end

addScenecontrol("createjacket", {"filename","size_px"}, function(cmd)
	local filename = cmd.args[1]
	local size = cmd.args[2]
	
	create_jacket(filename, size)
end)

addScenecontrol("changetojacket", {"end_timing","filename","easing"}, function(cmd)
	local timing = cmd.timing
	local end_timing = cmd.args[1]
	local filename = cmd.args[2]
	local easing = cmd.args[3]
	
	change_jacket(timing, end_timing, filename, easing)
end)
