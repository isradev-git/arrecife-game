extends SceneTree

const CANDIDATE = "res://../trabajo/arte/personajes/sota/caminar_v2/contacto_identidad_v1.png"


func _initialize() -> void:
	call_deferred("check")


func measure(image: Image, area: Rect2i) -> Dictionary:
	var low := area.end
	var high := area.position
	var brightness := 0.0
	var count := 0
	for y in range(area.position.y, area.end.y):
		for x in range(area.position.x, area.end.x):
			var color := image.get_pixel(x, y)
			if color.a >= 0.1:
				low.x = mini(low.x, x)
				low.y = mini(low.y, y)
				high.x = maxi(high.x, x)
				high.y = maxi(high.y, y)
			if color.a >= 0.95:
				brightness += 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b
				count += 1
	assert(count > 1000)
	return {"region": [low.x, low.y, high.x - low.x + 1, high.y - low.y + 1], "luminancia_srgb_media": brightness / count, "pixeles_opacos": count}


func check() -> void:
	var original: Image = preload("res://assets/personajes/sota/perfiles_pixel_v7.png").get_image()
	var candidate := Image.load_from_file(ProjectSettings.globalize_path(CANDIDATE))
	var old: Image = preload("res://assets/personajes/sota/caminar_derecha_v4.png").get_image()
	assert(candidate.get_size() == Vector2i(1536, 1024) and candidate.get_pixel(0, 0).a == 0.0)
	var reference := measure(original, Rect2i(0, 0, 768, 1024))
	var proposal := measure(candidate, Rect2i(768, 0, 768, 1024))
	var rejected := measure(old, Rect2i(0, 0, 384, 512))
	print("Luminancia media sRGB / región: v7 ", reference, " nueva ", proposal, " rechazada ", rejected)
	var file := FileAccess.open("res://../trabajo/arte/revisiones/marcha_identidad_v2/medidas.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"v7_original": reference, "contacto_nuevo": proposal, "contacto_rechazado": rejected, "nota": "Promedio de luminancia sobre alfa >= 0.95; pesos sobre RGB codificado, no medición fotométrica. Diferencia de forma cambia distribución de colores: no prueba identidad ni aprobación."}, "\t"))
	file.close()
	if DisplayServer.get_name() != "headless" and "--capturas" in OS.get_cmdline_user_args():
		await capture(candidate, proposal)
	quit()


func frame(viewport: SubViewport) -> Image:
	for index in range(4):
		await process_frame
	await RenderingServer.frame_post_draw
	return viewport.get_texture().get_image()


func capture(image: Image, measured: Dictionary) -> void:
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1672, 941)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var scene = load("res://recorrido.tscn").instantiate()
	viewport.add_child(scene)
	scene.set_physics_process(false)
	scene.body.position = Vector2(660, 705)
	scene.ground = scene.body.position
	scene.update_status()
	var r: Array = measured.region
	var texture := AtlasTexture.new()
	texture.atlas = ImageTexture.create_from_image(image)
	texture.region = Rect2(r[0], r[1], r[2], r[3])
	texture.filter_clip = true
	var sprite := Sprite2D.new()
	sprite.centered = false
	sprite.texture = texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.material = scene.sota.material
	sprite.scale = Vector2.ONE * 252.0 / 871.0
	sprite.offset = Vector2(-r[2] / 2.0, -r[3])
	sprite.position = Vector2(880, 705)
	sprite.z_index = 0
	scene.add_child(sprite)
	for sample in [[580.0, "V7 original · reposo 252"], [800.0, "Contacto nuevo · mismo shader/escala"]]:
		var label := Label.new()
		label.position = Vector2(sample[0], 420)
		label.text = sample[1]
		scene.add_child(label)
	var picture := await frame(viewport)
	assert(picture.save_png("res://../trabajo/arte/revisiones/marcha_identidad_v2/comparacion_velvet.png") == OK)
	for child in scene.get_children():
		if child is CanvasLayer:
			child.hide()
	scene.sota.reparent(viewport)
	sprite.reparent(viewport)
	for index in range(2):
		var person: Sprite2D = scene.sota if index == 0 else sprite
		person.position = Vector2(470 + index * 700, 800)
		person.scale *= 2.0
		var label := Label.new()
		label.position = Vector2(300 + index * 700, 200)
		label.text = "V7 original" if index == 0 else "Contacto nuevo · propuesta"
		viewport.add_child(label)
	scene.queue_free()
	picture = await frame(viewport)
	assert(picture.save_png("res://../trabajo/arte/revisiones/marcha_identidad_v2/comparacion_2x.png") == OK)
	viewport.queue_free()
	await process_frame
