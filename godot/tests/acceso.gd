extends SceneTree

var viewport := SubViewport.new()


func _initialize() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("La prueba de acceso necesita render gráfico; ejecutar sin --headless.")
		quit(1)
		return
	call_deferred("check")


func frame() -> Image:
	for index in range(4):
		await process_frame
	await RenderingServer.frame_post_draw
	return viewport.get_texture().get_image()


func front_metal_at(scene, rail_image: Image, point: Vector2i) -> bool:
	for segment in [scene.railing] + scene.railing.get_children():
		var local: Vector2 = segment.to_local(Vector2(point) + Vector2(0.5, 0.5))
		if local.x >= 0 and local.x < rail_image.get_width() and local.y >= 0 and local.y < rail_image.get_height():
			if rail_image.get_pixelv(Vector2i(local)).a >= 0.5:
				return true
	return false


func check() -> void:
	viewport.size = Vector2i(1672, 941)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var scene = load("res://revision_escala.tscn").instantiate()
	viewport.add_child(scene)
	for child in scene.get_children():
		if child is CanvasLayer:
			child.visible = false
	var check_companion := "--acompanante" in OS.get_cmdline_user_args()
	var actor: Sprite2D = scene.access_companion if check_companion else scene.access_person
	var other: Sprite2D = scene.access_person if check_companion else scene.access_companion
	var bounds := Rect2(actor.position, actor.texture.get_size() * actor.scale)
	assert(actor.texture.atlas.get_image().detect_alpha() != Image.ALPHA_NONE)
	assert(actor.texture.atlas.get_image().get_pixel(0, 0).a == 0.0)
	assert(actor.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
	assert(scene.access_patch.z_index < actor.z_index and actor.z_index < scene.sota.z_index)
	assert(scene.sota.z_index < scene.railing.z_index)
	assert(is_equal_approx(actor.position.y + actor.texture.get_height() * actor.scale.y, scene.BACK_EDGE_Y))
	assert(actor.material != scene.staff.material and actor.material != other.material)
	other.hide()
	scene.sota.hide()
	scene.set_railings(false, false)
	actor.hide()
	scene.access_patch.hide()
	var original := await frame()
	scene.access_patch.show()
	var repaired := await frame()
	var changed := 0
	for y in range(941):
		for x in range(1672):
			var point := Vector2i(x, y)
			if not scene.ACCESS_PATCH_RECT.has_point(Vector2(point)):
				assert(original.get_pixelv(point) == repaired.get_pixelv(point))
			elif original.get_pixelv(point) != repaired.get_pixelv(point):
				changed += 1
	assert(changed > 5000)
	actor.show()
	var lit := await frame()
	var other_rim = other.material.get_shader_parameter("rim_strength")
	actor.material.set_shader_parameter("rim_strength", 0.0)
	var neutral := await frame()
	assert(other.material.get_shader_parameter("rim_strength") == other_rim)
	var colored := 0
	for y in range(int(bounds.position.y), int(bounds.end.y)):
		for x in range(int(bounds.position.x), int(ceil(bounds.end.x))):
			if lit.get_pixel(x, y) != neutral.get_pixel(x, y):
				colored += 1
	assert(colored > 100)
	actor.material.set_shader_parameter("rim_strength", 0.7)
	actor.hide()
	scene.set_railings(false, true)
	var rail_only := await frame()
	actor.show()
	var front := await frame()
	var rail_image: Image = scene.railing.texture.get_image()
	var person_image: Image = actor.texture.get_image()
	var covered := 0
	var openings := 0
	for y in range(609, 675):
		for x in range(int(bounds.position.x), int(ceil(bounds.end.x))):
			var point := Vector2i(x, y)
			var local: Vector2 = actor.to_local(Vector2(point) + Vector2(0.5, 0.5))
			if local.x >= person_image.get_width() or local.y >= person_image.get_height() or person_image.get_pixelv(Vector2i(local)).a < 0.95:
				continue
			if front_metal_at(scene, rail_image, point):
				assert(front.get_pixelv(point) == rail_only.get_pixelv(point))
				covered += 1
			else:
				assert(front.get_pixelv(point) == lit.get_pixelv(point))
				openings += 1
	assert(covered > 100 and openings > 100)
	for pose in range(2):
		scene.set_railings(false, false)
		scene.set_ground(1625.0 if check_companion else 1560.0)
		scene.show_pose(pose)
		scene.sota.show()
		actor.hide()
		var sota_only := await frame()
		actor.show()
		var composed := await frame()
		var preserved := 0
		var sota_image: Image = scene.sota.texture.get_image()
		for y in range(453, 675):
			for x in range(int(bounds.position.x), int(ceil(bounds.end.x))):
				var local: Vector2 = scene.sota.to_local(Vector2(x + 0.5, y + 0.5)) - scene.sota.offset
				if local.x < 0 or local.y < 0 or local.x >= sota_image.get_width() or local.y >= sota_image.get_height():
					continue
				var alpha := sota_image.get_pixelv(Vector2i(local)).a
				if alpha >= 0.95:
					var delta := composed.get_pixel(x, y) - sota_only.get_pixel(x, y)
					assert(maxf(absf(delta.r), maxf(absf(delta.g), absf(delta.b))) <= 1.0 - alpha + 2.0 / 255.0)
					preserved += 1
		assert(preserved > 1500)
		print("OK ", "acompañante" if check_companion else "mochila", " perfil ", pose, ": ", preserved, " muestras de Sota delante del acceso.")
	print("OK: parche ", changed, "; contraluz ", colored, "; metal delante ", covered, "; aberturas ", openings, ". Fuera del parche idéntico, alfa y apoyo correctos.")
	if "--capturas" in OS.get_cmdline_user_args():
		var directory := ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/acompanante_v1/")
		for entry in [["galeria", 780.0, 0, true, true, true], ["cruce_0", 1625.0, 0, true, true, true], ["cruce_1", 1625.0, 1, true, true, true], ["sin_acompanante", 780.0, 0, true, false, true], ["entrada_vacia", 780.0, 0, false, false, true], ["solo_acompanante", 780.0, 0, false, true, true], ["sin_delantera", 780.0, 0, true, true, false]]:
			scene.set_ground(entry[1])
			scene.show_pose(entry[2])
			scene.access_person.visible = entry[3]
			scene.access_companion.visible = entry[4]
			scene.set_railings(true, entry[5])
			var capture := await frame()
			assert(capture.save_png(directory.path_join("godot_" + entry[0] + ".png")) == OK)
	quit()
