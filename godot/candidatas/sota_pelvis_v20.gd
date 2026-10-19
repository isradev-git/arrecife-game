extends "res://candidatas/sota_postura_v19.gd"

func cloth_point(leg: Dictionary, source: Vector2, hip: Vector2, knee: Vector2, ankle: Vector2) -> Vector2:
	var upper: Vector2 = hip+stretched(source-leg.hip,leg.thigh_axis,(knee-hip).length()).rotated(leg.thigh.rotation)
	var lower: Vector2 = knee+stretched(source-leg.neutral_knee,leg.shin_axis,(ankle-knee).length()).rotated(leg.shin.rotation)
	var cloth := upper.lerp(lower,smoothstep(leg.neutral_knee.y-9,leg.neutral_knee.y+9,source.y))
	var pelvic := source+Vector2(hip.x-leg.hip.x,0)
	# La bragueta y el tiro pertenecen a la pelvis; el giro se reparte más abajo, en el muslo.
	var start := (530.0-hip_source.y)*pixel_scale
	var end := (610.0-hip_source.y)*pixel_scale
	cloth=pelvic.lerp(cloth,smoothstep(start,end,source.y))
	var foot: Vector2 = ankle+(source-leg.neutral_ankle).rotated(leg.boot.rotation)
	return cloth.lerp(foot,smoothstep(leg.neutral_ankle.y-28,leg.neutral_ankle.y-18,source.y))
