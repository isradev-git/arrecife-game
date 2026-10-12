extends SceneTree


func _initialize() -> void:
	call_deferred("check_scene")


func check_scene() -> void:
	var scene = load("res://revision_escala.tscn").instantiate()
	root.add_child(scene)
	assert(scene.LABELS.size() == 2)
	assert(scene.art_index == 0)
	assert(scene.sota.texture.atlas == scene.ATLASES[0])
	assert(scene.sota.material.shader == scene.CUTOUT)
	assert(scene.sota.material.get_shader_parameter("recolor_rim") == false)
	assert(scene.sota.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
	for art in range(2):
		scene.set_art(art)
		assert(scene.views.size() == 2)
		assert(scene.views[0]["vista"] == "perfil_derecho")
		assert(scene.views[1]["vista"] == "perfil_izquierdo")
		for height in scene.HEIGHTS:
			scene.set_height(height)
			for index in range(2):
				scene.show_pose(index)
				var sprite: Sprite2D = scene.sota
				var texture: AtlasTexture = sprite.texture
				assert(texture.region.position.x >= 0 and texture.region.end.x <= texture.atlas.get_width())
				var cell: Array = scene.views[index]["region"]
				assert(texture.region.position.y >= cell[1] and texture.region.end.y <= cell[1] + cell[3])
				assert(is_equal_approx(texture.get_height() * sprite.scale.y, height))
				var sole: Vector2 = sprite.position + (sprite.offset + Vector2(texture.get_width() / 2.0, texture.get_height())) * sprite.scale
				assert(sole.is_equal_approx(scene.ground))
				assert(not sprite.flip_h)
	var image: Image = scene.ATLASES[1].get_image()
	assert(image.detect_alpha() != Image.ALPHA_NONE)
	for y in image.get_height():
		assert(image.get_pixel(0, y).a == 0.0)
		assert(image.get_pixel(image.get_width() / 2, y).a == 0.0)
		assert(image.get_pixel(image.get_width() - 1, y).a == 0.0)
	scene.set_art(1)
	scene.set_ground(1160.0)
	assert(scene.sota.position == Vector2(1160, scene.GROUND_Y))
	for x in [160.0, 450.0, 780.0, 935.0, 1160.0, 1260.0, 1500.0]:
		scene.set_ground(x)
		assert(scene.sota.position == Vector2(x, scene.GROUND_Y))
		var sole: Vector2 = scene.sota.position + (scene.sota.offset + Vector2(scene.sota.texture.get_width() / 2.0, scene.sota.texture.get_height())) * scene.sota.scale
		assert(sole.is_equal_approx(Vector2(x, scene.GROUND_Y)))
	assert(scene.BACK_EDGE_Y < scene.GROUND_Y and scene.GROUND_Y < scene.FRONT_EDGE_Y)
	assert(is_equal_approx(scene.GROUND_Y - scene.BACK_EDGE_Y, scene.FRONT_EDGE_Y - scene.GROUND_Y))
	assert(is_equal_approx(scene.railing.position.y + scene.railing.texture.get_height() * scene.railing.scale.y, scene.FRONT_EDGE_Y))
	assert(is_equal_approx(scene.back_railing.position.y + scene.back_railing.texture.get_height() * scene.back_railing.scale.y, scene.BACK_EDGE_Y))
	assert(scene.back_railing.z_index < scene.sota.z_index and scene.sota.z_index < scene.railing.z_index)
	assert(scene.back_railing.visible and scene.railing.visible)
	var segments := [scene.railing.get_child(0), scene.railing.get_child(1), scene.railing, scene.railing.get_child(2), scene.railing.get_child(3), scene.railing.get_child(4)]
	var end_x := 0.0
	for segment in segments:
		var start: Vector2 = segment.to_global(Vector2.ZERO)
		var end: Vector2 = segment.to_global(Vector2(segment.texture.get_width(), segment.texture.get_height()))
		assert(start.x <= end_x and is_equal_approx(end.y, scene.FRONT_EDGE_Y))
		assert(segment.material == scene.railing.material)
		end_x = end.x
	assert(end_x >= scene.BACKGROUND.get_width())
	for visible in [false, true]:
		scene.set_railings(true, visible)
		for segment in segments:
			assert(segment.is_visible_in_tree() == visible)
		assert(scene.back_railing.visible)
	scene.toggle_filter()
	assert(scene.sota.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR)
	scene.toggle_filter()
	assert(scene.sota.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
	scene.set_height(252.0)
	scene.show_pose(0)
	for art in range(2):
		scene.set_art(art)
		for lighting in range(scene.LIGHT_LABELS.size()):
			scene.set_lighting(lighting)
			assert(scene.light_index == lighting)
			if art == 0:
				assert(scene.sota.material.shader == scene.CUTOUT)
				assert(scene.sota.material.get_shader_parameter("recolor_rim") == (lighting != 0))
			else:
				assert(scene.sota.material.shader == scene.RIM_LIGHT)
				assert(is_equal_approx(scene.sota.material.get_shader_parameter("rim_strength"), 0.0 if lighting == 1 else 0.7))
				if lighting > 1:
					assert(scene.sota.material.get_shader_parameter("left_color") == scene.RIM_COLORS[lighting])
					assert(scene.sota.material.get_shader_parameter("right_color") == scene.RIM_COLORS[lighting])
			assert(scene.sota.position == scene.ground)
	scene.set_lighting(0)
	assert(scene.art_index == 1 and scene.pose_index == 0)
	print("OK: dos versiones, solo perfiles, tres alturas, apoyo estable, transparencia, filtros y color del contorno.")
	quit()
