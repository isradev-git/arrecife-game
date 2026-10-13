extends "res://tests/identidad_marcha.gd"

const OUTPUT = "res://../trabajo/arte/revisiones/marcha_poses_oscuras_v1/"
const SOURCES = ["contacto_identidad_v1", "apoyo_v1", "cruce_v1", "impulso_v1"]
const NAMES = ["V7 original · reposo", "Contacto", "Apoyo", "Cruce", "Impulso"]


func check() -> void:
	var images: Array[Image] = [preload("res://assets/personajes/sota/perfiles_pixel_v7.png").get_image()]
	var measures: Array[Dictionary] = [measure(images[0], Rect2i(0, 0, 768, 1024))]
	for source in SOURCES:
		var image := Image.load_from_file(ProjectSettings.globalize_path("res://../trabajo/arte/personajes/sota/caminar_v2/" + source + ".png"))
		assert(image != null and image.get_size() == Vector2i(1536, 1024))
		assert(image.get_pixel(0, 0).a == 0.0 and image.get_pixel(1535, 1023).a == 0.0)
		var measured := measure(image, Rect2i(768, 0, 768, 1024))
		var r: Array = measured.region
		assert(r[0] > 768 and r[0] + r[2] < 1536 and r[1] > 0 and r[1] + r[3] < 1024)
		assert(r[3] > 820 and r[3] < 900)
		var ratio: float = measured.luminancia_srgb_media / measures[0].luminancia_srgb_media
		assert(ratio > 0.8 and ratio < 1.15, "Revisar desviación tonal: " + source)
		images.append(image)
		measures.append(measured)
	var file := FileAccess.open(OUTPUT + "medidas.json", FileAccess.WRITE)
	assert(file != null)
	file.store_string(JSON.stringify({"nombres": NAMES, "medidas": measures, "escala_comun": 252.0 / 871.0, "nota": "RGB sRGB codificado sobre alfa >= 0.95; promedio afectado por forma y cobertura. No prueba identidad, paleta exacta ni aprobación. Encuadre estático por contorno; pivote de locomoción pendiente."}, "\t"))
	file.close()
	if DisplayServer.get_name() != "headless" and "--capturas" in OS.get_cmdline_user_args():
		await capture_series(images, measures)
	print("Poses oscuras: alfa, márgenes, dimensiones, altura y rango tonal comprobados. ", measures)
	quit()


func capture_series(images: Array[Image], measures: Array[Dictionary]) -> void:
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1672, 941)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var scene = load("res://recorrido.tscn").instantiate()
	viewport.add_child(scene)
	scene.set_physics_process(false)
	scene.sota.hide()
	for child in scene.get_children():
		if child is CanvasLayer:
			child.hide()
	var sprites: Array[Sprite2D] = []
	var labels: Array[Label] = []
	for index in range(images.size()):
		var r: Array = measures[index].region
		var texture := AtlasTexture.new()
		texture.atlas = ImageTexture.create_from_image(images[index])
		texture.region = Rect2(r[0], r[1], r[2], r[3])
		texture.filter_clip = true
		var sprite := Sprite2D.new()
		sprite.centered = false
		sprite.texture = texture
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.material = scene.sota.material
		sprite.scale = Vector2.ONE * 252.0 / 871.0
		sprite.offset = Vector2(-r[2] / 2.0, -r[3])
		sprite.position = Vector2(350 + index * 250, 705)
		scene.add_child(sprite)
		sprites.append(sprite)
		var label := Label.new()
		label.text = NAMES[index]
		label.position = Vector2(sprite.position.x - 80, 420)
		scene.add_child(label)
		labels.append(label)
	var picture := await frame(viewport)
	assert(picture.save_png(OUTPUT + "comparacion_velvet.png") == OK)
	for index in range(sprites.size()):
		sprites[index].reparent(viewport)
		sprites[index].position = Vector2(175 + index * 330, 820)
		sprites[index].scale *= 2.0
		labels[index].reparent(viewport)
		labels[index].position = Vector2(95 + index * 330, 245)
	scene.queue_free()
	picture = await frame(viewport)
	assert(picture.save_png(OUTPUT + "comparacion_2x.png") == OK)
	viewport.queue_free()
	await process_frame
