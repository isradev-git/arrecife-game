extends SceneTree


func _initialize() -> void:
	call_deferred("check_scene")


func check_scene() -> void:
	var scene = load("res://revision_escala.tscn").instantiate()
	root.add_child(scene)
	assert(scene.LABELS.size() == 2)
	assert(scene.art_index == 1)
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
	assert(scene.sota.position == Vector2(1160,710))
	scene.toggle_filter()
	assert(scene.sota.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR)
	scene.toggle_filter()
	assert(scene.sota.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST)
	scene.set_height(252.0)
	scene.show_pose(0)
	print("OK: dos versiones, solo perfiles, tres alturas, apoyo estable, transparencia y filtros.")
	quit()
