extends SceneTree

const WALK = preload("res://animacion_marcha.gd")
var walk := WALK.new()


func _initialize() -> void:
	call_deferred("check")


func check() -> void:
	for profile in range(2):
		assert(walk.frames[profile].size() == 8)
		for index in range(8):
			var texture: AtlasTexture = walk.frames[profile][index]
			assert(texture.get_size() == Vector2(512, 544))
			assert(texture.filter_clip)
			assert(texture.margin.position.x >= 0.0 and texture.margin.position.y >= 0.0)
			assert(texture.margin.position.x <= texture.margin.size.x and texture.margin.position.y <= texture.margin.size.y)
			var image: Image = texture.atlas.get_image()
			assert(image.get_pixel(0, 0).a == 0.0)
			assert(Rect2(Vector2.ZERO, image.get_size()).encloses(texture.region))
			assert(walk.frame_at(index * walk.data.distancia_ciclo / 8.0) == index)
	assert(walk.frame_at(walk.data.distancia_ciclo) == 0)
	assert(walk.frames[0][0].atlas != walk.frames[1][0].atlas)
	var scene = load("res://recorrido.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	await physics_frame
	await process_frame
	assert(not scene.step_preview.button_pressed)
	scene.step_preview.button_pressed = true
	for profile in range(2):
		scene.cancel_movement()
		scene.body.position = Vector2(780, 705)
		scene.show_pose(profile)
		var seen = {}
		for tick in range(90):
			scene.advance(1.0 / 60.0, 1.0 if profile == 0 else -1.0)
			seen[scene.walk_frame] = true
			assert(scene.walk_frame == scene.walk.frame_at(scene.walked_distance))
			assert(not scene.sota.flip_h and not scene.sota.flip_v)
			assert(scene.body.position.y == 705.0)
			assert(scene.sota.scale.is_equal_approx(Vector2.ONE * 252.0 / 470.0))
			assert(scene.sota.material.shader == walk.material.shader)
			var texture: AtlasTexture = scene.sota.texture
			var bottom = scene.sota.offset.y + texture.margin.position.y + texture.region.size.y
			assert(is_zero_approx(bottom))
		assert(seen.size() == 8 and not seen.has(-1))
		scene.cancel_movement()
		scene.advance(1.0 / 60.0, 0.0)
		assert(scene.walk_frame == -1 and scene.sota.texture.atlas == scene.ATLASES[0])
		assert(scene.sota.material.shader == scene.CUTOUT)
	scene.step_preview.button_pressed = false
	scene.advance(1.0 / 60.0, 1.0)
	assert(scene.walk_frame == -1 and scene.sota.texture.atlas == scene.ATLASES[0])
	print("OK: 16 poses, marcos/pivote/escala comunes, alfa, dos atlas propios, fases por distancia, ambos sentidos y retorno a v7.")
	scene.queue_free()
	await process_frame
	if "--capturas" in OS.get_cmdline_user_args() and DisplayServer.get_name() != "headless":
		await capture()
	quit()


func rendered(viewport: SubViewport) -> Image:
	for index in range(4):
		await process_frame
	await RenderingServer.frame_post_draw
	return viewport.get_texture().get_image()


func capture() -> void:
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1672, 984)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	for profile in range(2):
		var page := Node2D.new()
		viewport.add_child(page)
		for index in range(9):
			var col := index % 4
			var row := index / 4
			var sprite := Sprite2D.new()
			sprite.centered = false
			sprite.position = Vector2(col * 418 + 209, row * 304 + 310)
			page.add_child(sprite)
			if index < 8:
				walk.apply(sprite, profile, index)
			else:
				var approved = load("res://revision_escala.tscn").instantiate()
				viewport.add_child(approved)
				approved.show_pose(profile)
				sprite.texture = approved.sota.texture
				sprite.material = approved.sota.material
				sprite.scale = approved.sota.scale
				sprite.offset = approved.sota.offset
				approved.queue_free()
			var line := Line2D.new()
			line.points = PackedVector2Array([Vector2(col * 418 + 30, row * 304 + 310), Vector2(col * 418 + 388, row * 304 + 310)])
			line.width = 1.0
			line.default_color = Color(0.35, 0.45, 0.5)
			page.add_child(line)
			var label := Label.new()
			label.position = Vector2(col * 418 + 30, row * 304 + 22)
			label.text = "%d · %s" % [index + 1, walk.data.perfiles[profile][index].fase] if index < 8 else "Referencia v7 · reposo 252"
			page.add_child(label)
		var img := await rendered(viewport)
		assert(img.save_png("res://../trabajo/arte/revisiones/marcha_poses_v1/lamina_%s.png" % ("derecha" if profile == 0 else "izquierda")) == OK)
		page.queue_free()
		await process_frame
	viewport.size = Vector2i(1672, 941)
	var scene = load("res://recorrido.tscn").instantiate()
	viewport.add_child(scene)
	scene.set_physics_process(false)
	scene.step_preview.button_pressed = true
	for profile in range(2):
		scene.show_pose(profile)
		scene.show_walk_frame(2)
		var img := await rendered(viewport)
		assert(img.save_png("res://../trabajo/arte/revisiones/marcha_poses_v1/velvet_%s.png" % ("derecha" if profile == 0 else "izquierda")) == OK)
	scene.queue_free()
	viewport.queue_free()
	await process_frame
