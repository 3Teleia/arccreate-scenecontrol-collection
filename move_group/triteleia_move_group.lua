local x_channels = {}
local y_channels = {}
local z_channels = {}

local x_judge_channels = {}
local y_judge_channels = {}
local z_judge_channels = {}

function move_group_visual(timing, end_timing, tg, x, y, z, easing)
	local movable_tg = Scene.getNoteGroup(tg)
	
	if x_channels[tg] == nil then
		x_channels[tg] = Channel.keyframe()
		.addKey(-10000,0)
		.addKey(timing, movable_tg.translationX.valueAt(timing), easing)
		.addKey(end_timing, x)
			
		movable_tg.translationX = x_channels[tg]
	end
	
	if y_channels[tg] == nil then
		y_channels[tg] = Channel.keyframe()
		.addKey(-10000,0)
		.addKey(timing, movable_tg.translationY.valueAt(timing), easing)
		.addKey(end_timing, y)
		
		movable_tg.translationY = y_channels[tg]
	end
	
	if z_channels[tg] == nil then
		z_channels[tg] = Channel.keyframe()
		.addKey(-10000,0)
		.addKey(timing, movable_tg.translationZ.valueAt(timing), easing)
		.addKey(end_timing, z)
		
		movable_tg.translationZ = z_channels[tg]
	end
	
	if x_channels[tg].valueAt(timing) ~= x then
		x_channels[tg]
		.addKey(timing, x_channels[tg].valueAt(timing), easing)
		.addKey(end_timing, x)
	end
	
	if y_channels[tg].valueAt(timing) ~= y then
		y_channels[tg]
		.addKey(timing, y_channels[tg].valueAt(timing), easing)
		.addKey(end_timing, y)
	end
	
	if z_channels[tg].valueAt(timing) ~= z then
		z_channels[tg]
		.addKey(timing, z_channels[tg].valueAt(timing), easing)
		.addKey(end_timing, z)
	end
	
end


function move_group_judge(timing, end_timing, tg, x, y, z, easing)
	local movable_tg = Scene.getNoteGroup(tg)
	
	if x_judge_channels[tg] == nil then
		x_judge_channels[tg] = Channel.keyframe()
		.addKey(-10000,0)
		.addKey(timing, movable_tg.judgeOffsetX.valueAt(timing), easing)
		.addKey(end_timing, x)
			
		movable_tg.judgeOffsetX = x_judge_channels[tg]
	end
	
	if y_judge_channels[tg] == nil then
		y_judge_channels[tg] = Channel.keyframe()
		.addKey(-10000,0)
		.addKey(timing, movable_tg.judgeOffsetY.valueAt(timing), easing)
		.addKey(end_timing, y)
		
		movable_tg.judgeOffsetY = y_judge_channels[tg]
	end
	
	if z_judge_channels[tg] == nil then
		z_judge_channels[tg] = Channel.keyframe()
		.addKey(-10000,0)
		.addKey(timing, movable_tg.judgeOffsetZ.valueAt(timing), easing)
		.addKey(end_timing, z)
		
		movable_tg.judgeOffsetZ = z_judge_channels[tg]
	end
	
	if x_judge_channels[tg].valueAt(timing) ~= x then
		x_judge_channels[tg]
		.addKey(timing, x_judge_channels[tg].valueAt(timing), easing)
		.addKey(end_timing, x)
	end
	
	if y_judge_channels[tg].valueAt(timing) ~= y then
		y_judge_channels[tg]
		.addKey(timing, y_judge_channels[tg].valueAt(timing), easing)
		.addKey(end_timing, y)
	end
	
	if z_judge_channels[tg].valueAt(timing) ~= z then
		z_judge_channels[tg]
		.addKey(timing, z_judge_channels[tg].valueAt(timing), easing)
		.addKey(end_timing, z)
	end
	
end


addScenecontrol("movenotes", {"end_timing","x","y","z","easing","movejudge"}, function(cmd)
	local timing = cmd.timing
	local end_timing = cmd.args[1]
	local x = cmd.args[2]
	local y = cmd.args[3]
	local z = cmd.args[4]
	local easing = cmd.args[5]
	local movejudge = cmd.args[6]
	
	local tg = cmd.timingGroup

	move_group_visual(timing, end_timing, tg, x, y, z, easing)

	if movejudge ~= 0 then
		move_group_judge(timing, end_timing, tg, x, y, z, easing)
	end
end)
