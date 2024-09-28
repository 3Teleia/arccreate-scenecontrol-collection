-- hide the track to use its original divide lines and what not
-- Scene.track.colorA = 0

local csTrackCanvases = {}
local csTrackAlphaChannels = {}
local currentBpm = Context.bpm(0) -- base group's bpm
local baseBpm = currentBpm.valueAt(0)

function trackFromImg(timing, name, skinSrc)
	local tile = Scene.createSprite(skinSrc,"default","background")
	tile.layer = "Background"
	tile.sort = 10000 + timing -- adjust layering by time of sc event
	tile.scaleX = 1.79
	tile.rotationX = 90
	tile.scaleY = 80
	tile.textureScaleY = tile.scaleY
	
	-- 150000ms is about 12 offsetY
	--tile.textureOffsetY = Channel.keyframe().addKey(-10000,0).addKey(SONG_LENGTH,12*SONG_LENGTH/150000) * (currentBpm / baseBpm)
	tile.textureOffsetY = Channel.saw("l",150000,0,12,0) * (currentBpm / baseBpm)
	
	tile.setParent(Scene.worldCanvas)
	
	csTrackAlphaChannels[name] = Channel.keyframe().addKey(-10000,0)
	tile.colorA = csTrackAlphaChannels[name]
	
	return tile
end

function csTrackDisplay(name, startTiming, endTiming, alpha, easing)
	csTrackAlphaChannels[name]
	.addKey(startTiming, csTrackAlphaChannels[name].valueAt(startTiming), easing)
	.addKey(endTiming, alpha)
end



addScenecontrol("makecstrack", {"name","skinsrc"}, function(cmd) 
	local timing = cmd.timing
	local name = cmd.args[1]
	local skinSrc = cmd.args[2]
	
	trackFromImg(timing, name, skinSrc)
end)

addScenecontrol("cstrackalpha", {"name","endTiming","alpha","easing"}, function(cmd) 
	local timing = cmd.timing
	local name = cmd.args[1]
	local ending = cmd.args[2]
	local alpha = cmd.args[3]
	local easing = cmd.args[4]
	
	csTrackDisplay(name, timing, ending, alpha, easing)
end)