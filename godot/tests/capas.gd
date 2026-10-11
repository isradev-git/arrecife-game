extends SceneTree

var viewport := SubViewport.new()


func _initialize() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("La prueba de oclusión necesita render gráfico; ejecutar sin --headless.")
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
	assert(scene.railing.texture.atlas.get_image().detect_alpha() != Image.ALPHA_NONE)
	var rail_image: Image = scene.railing.texture.get_image()
	scene.set_railings(false, false)
	scene.sota.visible = false
	var empty := await frame()
	scene.set_railings(false, true)
	var rail_only := await frame()
	for pose in range(2):
		scene.show_pose(pose)
		scene.sota.visible = true
		scene.set_railings(false, false)
		var person := await frame()
		scene.set_railings(false, true)
		var front := await frame()
		scene.set_railings(true, false)
		var behind := await frame()
		scene.set_railings(true, true)
		var both := await frame()
		var covered := 0
		var openings := 0
		for y in range(int(scene.railing.position.y), int(scene.FRONT_EDGE_Y)):
			for x in range(450, 935):
				var point := Vector2i(x, y)
				if person.get_pixelv(point) == empty.get_pixelv(point):
					continue
				var local: Vector2 = (Vector2(point) + Vector2(0.5, 0.5) - scene.railing.position) / scene.railing.scale
				if rail_image.get_pixelv(Vector2i(local)).a < 0.5:
					assert(front.get_pixelv(point) == person.get_pixelv(point))
					openings += 1
				else:
					assert(front.get_pixelv(point) == rail_only.get_pixelv(point))
					assert(both.get_pixelv(point) == rail_only.get_pixelv(point))
					covered += 1
		var person_image: Image = scene.sota.texture.get_image()
		var back_visible := 0
		for y in range(int(scene.back_railing.position.y), int(scene.BACK_EDGE_Y)):
			for x in range(450, 935):
				var point := Vector2i(x, y)
				var local: Vector2 = (Vector2(point) + Vector2(0.5, 0.5) - scene.sota.position) / scene.sota.scale - scene.sota.offset
				if local.x < 0 or local.y < 0 or local.x >= person_image.get_width() or local.y >= person_image.get_height():
					continue
				var alpha := person_image.get_pixelv(Vector2i(local)).a
				var back_local: Vector2 = (Vector2(point) + Vector2(0.5, 0.5) - scene.back_railing.position) / scene.back_railing.scale
				if alpha >= 0.95 and rail_image.get_pixelv(Vector2i(back_local)).a >= 0.5:
					var delta := behind.get_pixelv(point) - person.get_pixelv(point)
					# El atlas tiene alfa casi opaco: solo debe contribuir su fracción transparente.
					assert(maxf(absf(delta.r), maxf(absf(delta.g), absf(delta.b))) <= 1.0 - alpha + 2.0 / 255.0)
					back_visible += 1
		print("OK perfil ", pose, ": ", covered, " píxeles ocultos por metal; ", openings, " visibles entre barrotes; ", back_visible, " conservados delante de la trasera.")
		assert(covered > 100 and openings > 100 and back_visible > 100)
	quit()
