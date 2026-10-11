extends SceneTree

var viewport := SubViewport.new()


func _initialize() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("La prueba de cabina necesita render gráfico; ejecutar sin --headless.")
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
	for sprite in [scene.guard, scene.booth_front]:
		assert(sprite.texture.atlas.get_image().detect_alpha() != Image.ALPHA_NONE)
		assert(sprite.texture.atlas.get_image().get_pixel(0, 0).a == 0.0)
		assert(sprite.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
	assert(scene.booth_patch.z_index < scene.guard.z_index and scene.guard.z_index < scene.booth_front.z_index)
	assert(scene.booth_front.z_index < scene.sota.z_index and scene.sota.z_index < scene.railing.z_index)
	assert(is_equal_approx(scene.guard.position.y + scene.guard.texture.get_height() * scene.guard.scale.y, scene.BACK_EDGE_Y))
	assert(scene.booth_front.position + scene.booth_front.texture.get_size() * scene.booth_front.scale == scene.BOOTH_RECT.end)
	assert(is_equal_approx(scene.BOOTH_RECT.end.y, scene.BACK_EDGE_Y))
	assert(scene.guard.material != scene.staff.material)
	scene.set_ground(300.0)
	assert(scene.review_panel.position.x >= scene.BOOTH_RECT.end.x)
	scene.set_ground(780.0)
	assert(scene.review_panel.position.x == 24.0)
	scene.sota.hide()
	scene.set_railings(false, false)
	scene.guard.hide()
	scene.booth_front.hide()
	scene.booth_patch.hide()
	var original := await frame()
	scene.booth_patch.show()
	var empty := await frame()
	var changed := 0
	for y in range(941):
		for x in range(1672):
			var point := Vector2i(x, y)
			if not scene.BOOTH_PATCH_RECT.has_point(Vector2(point)):
				assert(original.get_pixelv(point) == empty.get_pixelv(point))
			elif original.get_pixelv(point) != empty.get_pixelv(point):
				changed += 1
	assert(changed > 5000)
	scene.guard.show()
	var person := await frame()
	scene.guard.hide()
	scene.booth_front.show()
	var facade := await frame()
	scene.guard.show()
	var composed := await frame()
	var guard_image: Image = scene.guard.texture.get_image()
	var facade_image: Image = scene.booth_front.texture.get_image()
	var covered := 0
	var openings := 0
	var blue_screen := 0
	for y in range(415, 675):
		for x in range(166, 268):
			var point := Vector2i(x, y)
			var local: Vector2 = scene.guard.to_local(Vector2(point) + Vector2(0.5, 0.5))
			if local.x >= guard_image.get_width() or local.y >= guard_image.get_height() or guard_image.get_pixelv(Vector2i(local)).a < 0.95:
				continue
			var front_local: Vector2 = scene.booth_front.to_local(Vector2(point) + Vector2(0.5, 0.5))
			if facade_image.get_pixelv(Vector2i(front_local)).a >= 0.5:
				assert(composed.get_pixelv(point) == facade.get_pixelv(point))
				covered += 1
			else:
				assert(composed.get_pixelv(point) == person.get_pixelv(point))
				openings += 1
				var color := composed.get_pixelv(point)
				if color.b > 0.6 and color.g > 0.35 and color.r < 0.3:
					blue_screen += 1
	assert(covered > 1000 and openings > 1000 and blue_screen > 10)
	for pose in range(2):
		scene.set_ground(210.0)
		scene.show_pose(pose)
		scene.sota.show()
		scene.guard.hide()
		scene.booth_front.hide()
		var sota_only := await frame()
		scene.guard.show()
		scene.booth_front.show()
		var all_layers := await frame()
		var sota_image: Image = scene.sota.texture.get_image()
		var preserved := 0
		for y in range(453, 675):
			for x in range(151, 277):
				var local: Vector2 = scene.sota.to_local(Vector2(x + 0.5, y + 0.5)) - scene.sota.offset
				if local.x < 0 or local.y < 0 or local.x >= sota_image.get_width() or local.y >= sota_image.get_height():
					continue
				var alpha := sota_image.get_pixelv(Vector2i(local)).a
				if alpha >= 0.95:
					var delta := all_layers.get_pixel(x, y) - sota_only.get_pixel(x, y)
					assert(maxf(absf(delta.r), maxf(absf(delta.g), absf(delta.b))) <= 1.0 - alpha + 2.0 / 255.0)
					preserved += 1
		assert(preserved > 1500)
		print("OK perfil ", pose, ": ", preserved, " muestras de Sota delante de cabina y guardia.")
	print("OK: parche ", changed, "; cuerpo oculto ", covered, "; ventanilla ", openings, "; terminal azul visible ", blue_screen, ". Alfa, apoyo, panel y planos correctos.")
	if "--capturas" in OS.get_cmdline_user_args():
		var directory := ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/cabina_v1/")
		for entry in [["galeria", 780.0, 0, true, true, true], ["frente_0", 300.0, 0, true, true, true], ["frente_1", 300.0, 1, true, true, true], ["sin_guardia", 300.0, 0, false, true, true], ["sin_frontal", 300.0, 0, true, false, true], ["interior", 300.0, 0, false, false, true], ["solo_trasera", 300.0, 0, true, true, false]]:
			scene.set_ground(entry[1])
			scene.show_pose(entry[2])
			scene.guard.visible = entry[3]
			scene.booth_front.visible = entry[4]
			scene.set_railings(true, entry[5])
			var capture := await frame()
			assert(capture.save_png(directory.path_join("godot_" + entry[0] + ".png")) == OK)
	quit()
