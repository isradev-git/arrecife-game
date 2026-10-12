extends SceneTree

var viewport := SubViewport.new()


func _initialize() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("La prueba de recepción necesita render gráfico; ejecutar sin --headless.")
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
	for sprite in [scene.staff, scene.equipment, scene.ledger]:
		assert(sprite.texture.atlas.get_image().detect_alpha() != Image.ALPHA_NONE)
		assert(sprite.texture.atlas.get_image().get_pixel(0, 0).a == 0.0)
		assert(sprite.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
	assert(scene.counter_patch.z_index < scene.staff.z_index)
	assert(scene.staff.z_index < scene.counter.z_index)
	assert(scene.counter.z_index < scene.equipment.z_index and scene.equipment.z_index < scene.sota.z_index)
	assert(is_equal_approx(scene.staff.position.y + scene.staff.texture.get_height() * scene.staff.scale.y, scene.BACK_EDGE_Y))
	assert(is_equal_approx(scene.equipment.position.y + scene.equipment.texture.get_height() * scene.equipment.scale.y, scene.counter.position.y))
	assert(scene.counter_patch.z_index < scene.ledger.z_index and scene.ledger.z_index < scene.staff.z_index)
	assert(is_equal_approx(scene.ledger.position.y + 408.0 * scene.ledger.scale.y, scene.counter.position.y))
	var staff_right := ceili(scene.staff.position.x + scene.staff.texture.get_width() * scene.staff.scale.x)
	scene.sota.hide()
	scene.set_railings(false, false)
	scene.staff.hide()
	scene.equipment.hide()
	scene.ledger.hide()
	var bare := await frame()
	scene.ledger.show()
	var book := await frame()
	scene.staff.show()
	var hands_and_book := await frame()
	scene.ledger.hide()
	var hands := await frame()
	var book_image: Image = scene.ledger.texture.get_image()
	var staff_image: Image = scene.staff.texture.get_image()
	var book_visible := 0
	var hands_preserved := 0
	for y in range(floori(scene.ledger.position.y), ceili(scene.ledger.position.y + scene.ledger.texture.get_height() * scene.ledger.scale.y)):
		for x in range(floori(scene.ledger.position.x), ceili(scene.ledger.position.x + scene.ledger.texture.get_width() * scene.ledger.scale.x)):
			var point := Vector2(x + 0.5, y + 0.5)
			var local: Vector2 = scene.ledger.to_local(point)
			if local.x < 0 or local.x >= book_image.get_width() or local.y < 0 or local.y >= book_image.get_height() or book_image.get_pixelv(Vector2i(local)).a < 0.5:
				continue
			var staff_local: Vector2 = scene.staff.to_local(point)
			var alpha := staff_image.get_pixelv(Vector2i(staff_local)).a if staff_local.x >= 0.0 else 0.0
			if alpha >= 0.95:
				var delta := hands_and_book.get_pixel(x,y) - hands.get_pixel(x,y)
				assert(maxf(absf(delta.r), maxf(absf(delta.g), absf(delta.b))) <= 1.0 - alpha + 2.0 / 255.0)
				hands_preserved += 1
			elif alpha < 0.1 and book.get_pixel(x,y) != bare.get_pixel(x,y):
				assert(hands_and_book.get_pixel(x,y) == book.get_pixel(x,y))
				book_visible += 1
	assert(hands_preserved > 10 and book_visible > 30)
	scene.counter.hide()
	scene.staff.hide()
	scene.equipment.hide()
	var empty := await frame()
	scene.staff.show()
	var worker := await frame()
	var changed_staff := 0
	for y in range(431, 675):
		for x in range(1328, staff_right):
			if worker.get_pixel(x, y) != empty.get_pixel(x, y):
				changed_staff += 1
	assert(changed_staff > 3000)
	scene.counter.show()
	var composed := await frame()
	scene.staff.hide()
	var furniture := await frame()
	var covered := 0
	var person: Image = scene.staff.texture.get_image()
	var metal: Image = scene.counter.texture.get_image()
	for y in range(538, 675):
		for x in range(1328, staff_right):
			var point := Vector2(x + 0.5, y + 0.5)
			var local: Vector2 = scene.staff.to_local(point)
			if local.x >= person.get_width() or local.y >= person.get_height():
				continue
			var alpha := person.get_pixelv(Vector2i(local)).a
			if alpha >= 0.95 and metal.get_pixelv(Vector2i(scene.counter.to_local(point))).a >= 0.5:
				assert(composed.get_pixel(x, y) == furniture.get_pixel(x, y))
				covered += 1
	assert(covered > 1000)
	scene.equipment.show()
	var equipped := await frame()
	var changed_equipment := 0
	for y in range(479, 538):
		for x in range(1218, 1342):
			if equipped.get_pixel(x, y) != furniture.get_pixel(x, y):
				changed_equipment += 1
	assert(changed_equipment > 500)
	for pose in range(2):
		scene.set_ground(1380.0)
		scene.show_pose(pose)
		scene.sota.show()
		scene.counter.hide()
		scene.equipment.hide()
		var sota_only := await frame()
		scene.ledger.show()
		scene.staff.show()
		scene.counter.show()
		scene.equipment.show()
		var all_layers := await frame()
		var preserved := 0
		var sota_image: Image = scene.sota.texture.get_image()
		for y in range(450, 675):
			for x in range(1328, staff_right):
				var local: Vector2 = scene.sota.to_local(Vector2(x + 0.5, y + 0.5)) - scene.sota.offset
				if local.x < 0 or local.y < 0 or local.x >= sota_image.get_width() or local.y >= sota_image.get_height():
					continue
				var alpha := sota_image.get_pixelv(Vector2i(local)).a
				if alpha >= 0.95:
					var delta := all_layers.get_pixel(x, y) - sota_only.get_pixel(x, y)
					assert(maxf(absf(delta.r), maxf(absf(delta.g), absf(delta.b))) <= 1.0 - alpha + 2.0 / 255.0)
					preserved += 1
		assert(preserved > 1500)
		print("OK perfil ", pose, ": ", preserved, " muestras de Sota delante de recepción.")
		scene.staff.hide()
		scene.ledger.hide()
	print("OK: jefa ", changed_staff, "; equipo ", changed_equipment, "; cuerpo oculto por mostrador ", covered, ". Alfa, apoyos y planos correctos.")
	print("OK: libro visible ", book_visible, "; manos delante ", hands_preserved, "; tapa apoyada en mostrador.")
	if "--capturas" in OS.get_cmdline_user_args():
		scene.set_ground(1345.0)
		scene.set_railings(true, true)
		var directory := ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/libro_v1/")
		for entry in [["galeria", true, true, true, 0, 780.0, true], ["completa_0", true, true, true, 0, 1345.0, true], ["completa_1", true, true, true, 1, 1345.0, true], ["sin_libro", true, true, true, 0, 780.0, false], ["sin_jefa", true, false, true, 0, 780.0, true], ["sin_equipo", true, true, false, 0, 780.0, true], ["interior", false, false, false, 0, 780.0, false]]:
			scene.set_ground(entry[5])
			scene.ledger.visible = entry[6]
			scene.counter.visible = entry[1]
			scene.staff.visible = entry[2]
			scene.equipment.visible = entry[3]
			scene.show_pose(entry[4])
			var capture := await frame()
			assert(capture.save_png(directory.path_join("godot_" + entry[0] + ".png")) == OK)
	quit()
