extends SceneTree

const MOTION = preload("res://movimiento.gd")


func _initialize() -> void:
	call_deferred("check")


func check() -> void:
	var walking := MOTION.new()
	var walk_x := 780.0
	walk_x = walking.step(walk_x, 1.0 / 60.0, 1.0)
	assert(walking.velocity > 0.0 and walking.velocity < MOTION.WALK_SPEED)
	for index in range(60):
		walk_x = walking.step(walk_x, 1.0 / 60.0, 1.0)
	assert(walking.velocity == MOTION.WALK_SPEED)
	var reversed := walking.step(walk_x, 1.0 / 60.0, -1.0)
	assert(reversed > walk_x)
	for index in range(40):
		reversed = walking.step(reversed, 1.0 / 60.0, -1.0)
	assert(walking.velocity < 0.0)
	for index in range(30):
		reversed = walking.step(reversed, 1.0 / 60.0, 0.0)
	assert(walking.velocity == 0.0)
	for destination in [MOTION.MIN_X, 779.99, 780.01, 800.0, 1260.0, 1480.0, MOTION.MAX_X]:
		var motion := MOTION.new()
		var x := 780.0
		assert(motion.go_to(destination))
		for index in range(600):
			x = motion.step(x, 1.0 / 60.0, 0.0)
			assert(x >= minf(780.0, destination) and x <= maxf(780.0, destination))
			if motion.arrived:
				break
		assert(motion.arrived and x == destination and motion.velocity == 0.0 and motion.target == null)
	var clamped := MOTION.new()
	assert(not clamped.go_to(NAN))
	assert(clamped.go_to(-999.0) and clamped.target == MOTION.MIN_X)
	assert(clamped.go_to(9999.0) and clamped.target == MOTION.MAX_X)
	var x := 780.0
	for index in range(600):
		x = clamped.step(x, 1.0 / 60.0, -1.0)
	assert(x == MOTION.MIN_X and clamped.velocity == 0.0 and clamped.target == null)
	for index in range(600):
		x = clamped.step(x, 1.0 / 60.0, 1.0)
	assert(x == MOTION.MAX_X and clamped.velocity == 0.0)
	var positions: Array[float] = []
	for fps in [30, 60]:
		var motion := MOTION.new()
		x = 780.0
		for index in range(fps):
			x = motion.step(x, 1.0 / fps, 1.0)
		positions.append(x)
	assert(absf(positions[0] - positions[1]) < 4.0)
	print("OK: aceleración, caminar sin carrera, frenada, inversión, 7 llegadas sin sobrepasar, límites, destinos inválidos y pasos 30/60.")
	await check_scene()
	quit()


func check_scene() -> void:
	var scene = load("res://recorrido.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	await physics_frame
	await process_frame
	assert(scene.art_index == 0 and scene.character_height == 252.0)
	assert(scene.sota.get_parent() == scene.body and scene.sota.position == Vector2.ZERO)
	assert(scene.body.get_child_count() == 2)
	scene.go_to(1260.0, 0, "Jefa")
	for index in range(400):
		scene.advance(1.0 / 60.0, 0.0)
	assert(is_equal_approx(scene.body.position.x, 1260.0) and scene.motion.velocity == 0.0 and scene.pose_index == 0)
	scene.go_to(300.0, 1, "guardia")
	for index in range(400):
		scene.advance(1.0 / 60.0, 0.0)
	assert(is_equal_approx(scene.body.position.x, 300.0) and scene.pose_index == 1)
	assert(scene.walk.state == "reposo" and scene.sota.position == Vector2.ZERO)
	var rest: Dictionary = scene.walk.data.perfiles[1].reposo
	var sole: Vector2 = scene.sota.to_global(scene.sota.offset + Vector2(rest.cadera_x - rest.celda[0], rest.suelo_y))
	assert(sole.is_equal_approx(Vector2(300, 705)))
	assert(scene.back_railing.z_index < scene.body.z_index and scene.body.z_index < scene.railing.z_index)
	for intent in [-1.0, 1.0]:
		for index in range(600):
			scene.advance(1.0 / 60.0, intent)
		assert(scene.body.position.x >= MOTION.MIN_X - 0.2 and scene.body.position.x <= MOTION.MAX_X + 0.2)
		assert(scene.body.position.y == 705.0)
	# Un obstáculo real del plano transitable debe detener el cuerpo, aunque el destino esté detrás.
	var obstacle := StaticBody2D.new()
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(16, 80)
	collider.shape = shape
	obstacle.add_child(collider)
	obstacle.position = Vector2(1100, 705)
	root.add_child(obstacle)
	scene.body.position = Vector2(780, 705)
	scene.cancel_movement()
	await physics_frame
	await process_frame
	scene.go_to(1480.0, 0, "acceso")
	for index in range(400):
		scene.advance(1.0 / 60.0, 0.0)
	assert(scene.body.position.x < 1080.1 and scene.body.position.x > 1079.0)
	assert(scene.motion.target == null and scene.motion.velocity == 0.0)
	obstacle.queue_free()
	await process_frame
	await physics_frame
	scene.go_to(1260.0)
	scene.pressed_keys[KEY_D] = true
	scene.get_window().focus_exited.emit()
	var stopped: Vector2 = scene.body.position
	for index in range(30):
		scene._physics_process(1.0 / 60.0)
	assert(scene.body.position == stopped and scene.pressed_keys.is_empty() and scene.motion.target == null)
	var event := InputEventKey.new()
	event.physical_keycode = KEY_D
	event.pressed = true
	scene._input(event)
	scene._physics_process(1.0 / 60.0)
	assert(scene.body.position.x > stopped.x)
	event.pressed = false
	scene._input(event)
	for index in range(30):
		scene._physics_process(1.0 / 60.0)
	assert(scene.motion.velocity == 0.0 and scene.pressed_keys.is_empty())
	var shift := InputEventKey.new()
	shift.physical_keycode = KEY_SHIFT
	shift.pressed = true
	scene._input(shift)
	event.pressed = true
	scene._input(event)
	for index in range(20):
		scene._physics_process(1.0 / 60.0)
	assert(scene.motion.velocity == MOTION.WALK_SPEED and KEY_SHIFT not in scene.pressed_keys)
	shift.pressed = false
	scene._input(shift)
	for index in range(20):
		scene._physics_process(1.0 / 60.0)
	assert(scene.motion.velocity == MOTION.WALK_SPEED)
	event.pressed = true
	scene._input(event)
	scene._physics_process(1.0 / 60.0)
	var escape := InputEventKey.new()
	escape.keycode = KEY_ESCAPE
	escape.pressed = true
	scene._input(escape)
	event.echo = true
	scene._input(event)
	assert(scene.pressed_keys.is_empty() and scene.motion.velocity == 0.0 and scene.motion.target == null)
	print("OK: escena 252/v7, pies 705, planos, puntos Jefa/guardia, colisiones físicas, pérdida de foco, nueva pulsación, liberación y Mayús sin aumento de velocidad.")
	if "--capturas" in OS.get_cmdline_user_args() and DisplayServer.get_name() != "headless":
		for sample in [[1260.0, 0, "jefa"], [300.0, 1, "guardia"]]:
			scene.go_to(sample[0], sample[1], sample[2])
			for index in range(600):
				scene.advance(1.0 / 60.0, 0.0)
			for index in range(4):
				await process_frame
			await RenderingServer.frame_post_draw
			assert(root.get_texture().get_image().save_png("res://../trabajo/arte/revisiones/solo_caminar_v1/nativo_%s.png" % sample[2]) == OK)
	scene.queue_free()
	await process_frame
