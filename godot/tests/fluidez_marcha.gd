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
			for tick in range(rate * 3):
				var old_x: float = scene.body.position.x
				scene.advance(1.0 / rate, direction)
				var travel: float = scene.body.position.x - old_x
				var visual: float = scene.sota.global_position.x - previous
				if tick > rate / 4:
					if absf(visual) < absf(travel) * 0.25:
						freezes += 1
					jump = maxf(jump, absf(visual - travel))
				previous = scene.sota.global_position.x
				if scene.walk.state == "marcha":
					seen[scene.walk.frame_index] = true
					var view: Dictionary = scene.walk.data.perfiles[profile]
					var pose: Dictionary = view.marcha[scene.walk.frame_index]
					var phase: float = scene.walk.distance + scene.walk.CYCLE_DISTANCE / 4.0
					var step: int = floori(phase / scene.walk.CYCLE_DISTANCE) * 2 + scene.walk.frame_index / 8
					if fposmod(phase, scene.walk.CYCLE_DISTANCE) > scene.walk.CYCLE_DISTANCE * 0.75 and scene.walk.frame_index < 4:
						step += 2
					var contact: Dictionary = view.marcha[0 if scene.walk.frame_index < 8 else 8]
					var toe: float = direction * (pose.apoyo_x - pose.cadera_x) * view.escala
					var anchor: float = direction * (contact.apoyo_x - contact.cadera_x) * view.escala
					foot_drift = maxf(foot_drift, absf(phase - step * scene.walk.CYCLE_DISTANCE / 2.0 + toe - anchor))
			print("Perfil %d · %d Hz: congelaciones %d, salto extra máximo %.3f px" % [profile, rate, freezes, jump])
			print("Desviación máxima de la puntera dibujada durante el apoyo: %.3f px" % foot_drift)
			if freezes > 0 or jump > 2.0 or foot_drift > 25.0 or seen.size() != 16:
				failures += 1
	scene.queue_free()
	await process_frame
	if failures > 0:
		printerr("FALLO: saltos/congelaciones de cadera o cadencia incompatible con los apoyos dibujados.")
	else:
		print("OK: avance visual continuo en ambos perfiles, sin congelaciones ni saltos de cadera.")
	quit(1 if failures > 0 else 0)
