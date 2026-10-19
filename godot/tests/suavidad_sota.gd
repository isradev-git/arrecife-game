extends SceneTree

const STABLE = "res://../trabajo/arte/personajes/sota/versiones/sota_0_1_stable/godot/sota_articulada.gd"

func _initialize() -> void: call_deferred("check")

func check() -> void:
	var script = load("res://sota_articulada.gd")
	if "--antes" in OS.get_cmdline_user_args():
		script=GDScript.new()
		script.source_code=FileAccess.get_file_as_string(STABLE)
		assert(script.reload()==OK)
	if "--modelo13" in OS.get_cmdline_user_args():
		script=GDScript.new()
		script.source_code=FileAccess.get_file_as_string("res://../trabajo/arte/revisiones/apoyo_sota_v14/sota_articulada_antes.gd.txt")
		assert(script.reload()==OK)
	var rig = script.new()
	root.add_child(rig)
	rig.build(0)
	var minimum := [180.0,180.0]
	var jumps := [0.0,0.0]
	var previous := [0.0,0.0]
	var lifts := [0.0,0.0]
	var ground_error := 0.0
	var support_max := [0.0,0.0]
	var swing_max := [0.0,0.0]
	var crouched := 0
	for sample in range(2049):
		var phase := sample/2048.0
		rig.pose(phase)
		var bent := 0
		for index in range(2):
			var leg: Dictionary = rig.legs[index]
			var angle := rad_to_deg((leg.shin.position-leg.thigh.position).angle_to(leg.boot.position-leg.shin.position))
			minimum[index]=minf(minimum[index],absf(angle))
			if sample>0: jumps[index]=maxf(jumps[index],absf(angle-previous[index]))
			previous[index]=angle
			var sole := -INF
			for point in leg.hull:
				sole=maxf(sole,(rig.body.position+leg.boot.position+point.rotated(leg.boot.rotation)).y)
			lifts[index]=maxf(lifts[index],-sole)
			var p := fposmod(phase+(0.5 if index==0 else 0.0),1.0)
			if p>=0.15 and p<=0.4: support_max[index]=maxf(support_max[index],absf(angle))
			if p>=0.6: swing_max[index]=maxf(swing_max[index],absf(angle))
			if absf(angle)>20.0: bent+=1
			if p<0.6: ground_error=maxf(ground_error,absf(sole))
		if bent==2: crouched+=1
	print("Flexión mínima: %s; salto angular por 1/2048 ciclo: %s; elevación: %s; error apoyo: %.6f" % [minimum,jumps,lifts,ground_error])
	print("Máxima flexión en apoyo medio: %s; recuperación: %s; muestras con ambas rodillas >20°: %d" % [support_max,swing_max,crouched])
	var passed: bool = minimum.min()>3.0 and minimum.max()<10.0 and support_max.max()<18.0 and swing_max.min()>45.0 and swing_max.max()<70.0 and crouched==0 and jumps.max()<1.0 and lifts.min()>15.0 and lifts.max()<24.0 and ground_error<0.001
	rig.free()
	quit(0 if passed else 1)
