extends SceneTree


func _initialize() -> void:
	call_deferred("check")


func check() -> void:
	var scene = load("res://recorrido.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	await process_frame
	await physics_frame
	var failures := 0
	for rate in [30, 60]:
		for profile in range(2):
			scene.cancel_movement()
			scene.body.position = Vector2(780, 705)
			scene.show_pose(profile)
			var direction := 1.0 if profile == 0 else -1.0
			var previous: float = scene.sota.global_position.x
			var freezes := 0
			var jump := 0.0
			var foot_drift := 0.0
			var seen: Dictionary = {}
			var anchors := [0.0,0.0]
			var steps := [-999,-999]
			for tick in range(rate * 3):
				var old_x: float = scene.body.position.x
				scene.advance(1.0 / rate, direction)
				var travel: float = scene.body.position.x - old_x
				var visual: float = scene.sota.global_position.x - previous
				if tick > rate / 4:
					if absf(visual) < absf(travel) * 0.25: freezes += 1
					jump = maxf(jump, absf(visual - travel))
				previous = scene.sota.global_position.x
				if scene.walk.state == "marcha":
					seen[scene.walk.frame_index] = true
					var view: Dictionary = scene.walk.data.perfiles[profile]
					var pose: Dictionary = view.marcha[scene.walk.frame_index]
					for foot in range(2):
						var phase: float = scene.walk.distance / scene.walk.CYCLE_DISTANCE + 0.25 + (0.5 if foot==0 else 0.0)
						var sampled: float = fposmod(scene.walk.frame_index / 32.0 + (0.5 if foot==0 else 0.0),1.0)
						if fposmod(phase,1.0)<0.03 or fposmod(phase,1.0)>0.56 or sampled>=0.6: continue
						var point: float = scene.body.position.x + (pose.punteras[foot][0] - 128.0) * (-1.0 if scene.sota.flip_h else 1.0)
						var step:=floori(phase)
						if steps[foot]!=step:
							steps[foot]=step
							anchors[foot]=point
						foot_drift=maxf(foot_drift,absf(point-anchors[foot]))
			print("Perfil %d · %d Hz: congelaciones %d, salto extra máximo %.3f px" % [profile, rate, freezes, jump])
			print("Desviación máxima de la puntera dibujada durante el apoyo: %.3f px" % foot_drift)
			if freezes > 0 or jump > 2.0 or foot_drift > 4.2 or seen.size() != 32:
				failures += 1
	scene.queue_free()
	await process_frame
	if failures > 0:
		printerr("FALLO: saltos/congelaciones de cadera o cadencia incompatible con los apoyos dibujados.")
	else:
		print("OK: avance visual continuo en ambos perfiles, sin congelaciones ni saltos de cadera.")
	quit(1 if failures > 0 else 0)
