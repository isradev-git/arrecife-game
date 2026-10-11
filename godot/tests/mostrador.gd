extends SceneTree

var viewport := SubViewport.new()


func _initialize() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("La prueba del mostrador necesita render gráfico; ejecutar sin --headless.")
		quit(1)
		return
	call_deferred("check")


func frame() -> Image:
	for index in range(4):
		await process_frame
	await RenderingServer.frame_post_draw
	return viewport.get_texture().get_image()


func check() -> void:
	viewport.size = Vector2i(1672, 941)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var scene = load("res://revision_escala.tscn").instantiate()
	viewport.add_child(scene)
	for child in scene.get_children():
		if child is CanvasLayer:
			child.visible = false
	assert(scene.counter.texture.atlas.get_image().detect_alpha() != Image.ALPHA_NONE)
	assert(scene.counter.texture.atlas.get_image().get_pixel(0, 0).a == 0.0)
	assert(scene.counter_patch.z_index < scene.counter.z_index)
	assert(scene.counter.z_index < scene.sota.z_index and scene.sota.z_index < scene.railing.z_index)
	assert(scene.counter.position + scene.counter.texture.get_size() * scene.counter.scale == scene.COUNTER_RECT.end)
	assert(is_equal_approx(scene.COUNTER_RECT.end.y, scene.BACK_EDGE_Y))
	scene.sota.hide()
	scene.set_railings(false, false)
	scene.counter.hide()
	scene.counter_patch.hide()
	var original := await frame()
	scene.counter_patch.show()
	var repaired := await frame()
	var changed := 0
	for y in range(941):
		for x in range(1672):
			var point := Vector2i(x, y)
			if not scene.COUNTER_PATCH_RECT.has_point(Vector2(point)):
				assert(original.get_pixelv(point) == repaired.get_pixelv(point))
			elif original.get_pixelv(point) != repaired.get_pixelv(point):
				changed += 1
	assert(changed > 5000)
	scene.counter.show()
	var furniture := await frame()
	var metal: Image = scene.counter.texture.get_image()
	var counter_changed := 0
	for y in range(538, 675):
		for x in range(1210, 1488):
			if furniture.get_pixel(x, y) != repaired.get_pixel(x, y):
				counter_changed += 1
	assert(counter_changed > 20000)
	for pose in range(2):
		scene.set_ground(1345.0)
		scene.show_pose(pose)
		scene.sota.show()
		scene.counter.hide()
		var person := await frame()
		scene.counter.show()
		var composed := await frame()
		var preserved := 0
		var person_image: Image = scene.sota.texture.get_image()
		for y in range(538, 675):
			for x in range(1210, 1488):
				var point := Vector2i(x, y)
				var local: Vector2 = scene.sota.to_local(Vector2(point) + Vector2(0.5, 0.5)) - scene.sota.offset
				if local.x < 0 or local.y < 0 or local.x >= person_image.get_width() or local.y >= person_image.get_height():
					continue
				var alpha := person_image.get_pixelv(Vector2i(local)).a
				var counter_local: Vector2 = scene.counter.to_local(Vector2(point) + Vector2(0.5, 0.5))
				if alpha >= 0.95 and metal.get_pixelv(Vector2i(counter_local)).a >= 0.5:
					var delta := composed.get_pixelv(point) - person.get_pixelv(point)
					assert(maxf(absf(delta.r), maxf(absf(delta.g), absf(delta.b))) <= 1.0 - alpha + 2.0 / 255.0)
					preserved += 1
		assert(preserved > 1000)
		print("OK perfil ", pose, ": ", preserved, " muestras de Sota delante del mostrador.")
	print("OK: ", changed, " píxeles reparados; escena intacta fuera del parche; alfa y apoyo correctos.")
	quit()
