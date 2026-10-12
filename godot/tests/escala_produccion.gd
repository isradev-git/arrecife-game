extends SceneTree

var viewport := SubViewport.new()


func _initialize() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("La comparación de escala necesita render gráfico.")
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
			child.hide()
	assert(scene.art_index == 0)
	var staff_position: Vector2 = scene.staff.position
	var staff_scale: Vector2 = scene.staff.scale
	var directory := ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/escala_produccion_v1/")
	for height in scene.HEIGHTS:
		scene.set_height(height)
		for pose in range(2):
			scene.show_pose(pose)
			for place in [["jefa", 1260.0], ["guardia", 300.0]]:
				scene.set_ground(place[1])
				var sole: Vector2 = scene.sota.position + (scene.sota.offset + Vector2(scene.sota.texture.get_width() / 2.0, scene.sota.texture.get_height())) * scene.sota.scale
				assert(sole.is_equal_approx(Vector2(place[1], 705.0)))
				assert(is_equal_approx(scene.sota.texture.get_height() * scene.sota.scale.y, height))
				assert(scene.staff.position == staff_position and scene.staff.scale == staff_scale)
				assert(is_equal_approx(scene.staff.texture.get_height() * scene.staff.scale.y, 244.0))
				assert(scene.sota.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
				assert(scene.staff.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
				var capture := await frame()
				assert(capture.get_size() == Vector2i(1672, 941))
				if "--capturas" in OS.get_cmdline_user_args():
					assert(capture.save_png(directory.path_join("godot_%s_%d_%d.png" % [place[0], height, pose])) == OK)
	scene.set_ground(1260.0)
	scene.set_height(252.0)
	scene.show_pose(0)
	# Comparación de raster, sin modificar PNG, pivotes ni la resolución de la escena principal.
	viewport.size = Vector2i(836, 471)
	viewport.canvas_transform = Transform2D(Vector2(0.5, 0), Vector2(0, 0.5), Vector2.ZERO)
	var coarse := await frame()
	assert(coarse.get_size() == Vector2i(836, 471))
	assert(scene.sota.position == Vector2(1260, 705))
	assert(scene.staff.position == staff_position and scene.staff.scale == staff_scale)
	if "--capturas" in OS.get_cmdline_user_args():
		assert(coarse.save_png(directory.path_join("godot_pixel_2.png")) == OK)
	print("OK: tres alturas, dos perfiles, dos posiciones; Jefa 244 intacta, apoyos 705/675, nearest; comparación de raster 1672×941 / 836×471.")
	quit()
