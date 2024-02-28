require "triteleia_track_skin"

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