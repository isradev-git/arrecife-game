extends "res://tests/identidad_marcha.gd"

const OUTPUT = "res://../trabajo/arte/revisiones/marcha_poses_oscuras_v1/"
const SOURCES = ["contacto_identidad_v1", "apoyo_v1", "cruce_v1", "impulso_v1"]
const NAMES = ["V7 original · reposo", "Contacto", "Apoyo", "Cruce", "Impulso"]
const INBETWEEN_OUTPUT = "res://../trabajo/arte/revisiones/marcha_intermedios_v1/"
const INBETWEEN_SOURCES = ["contacto_identidad_v1", "contacto_apoyo_v3", "apoyo_v1", "apoyo_cruce_v1", "cruce_v1", "cruce_impulso_v3", "impulso_v1"]
const INBETWEEN_NAMES = ["V7 original · reposo", "01 · Contacto", "02 · Carga", "03 · Apoyo", "04 · Despegue", "05 · Cruce", "06 · Extensión", "07 · Impulso"]
const SLEEVE_OUTPUT = "res://../trabajo/arte/revisiones/marcha_mangas_v1/"
const SECOND_OUTPUT = "res://../trabajo/arte/revisiones/marcha_segundo_paso_v1/"
const SECOND_SOURCES = ["contacto_b_v4", "apoyo_b_v2", "cruce_b_v6", "impulso_b_v4"]
const SECOND_NAMES = ["V7 original · reposo", "B · Contacto", "B · Apoyo", "B · Cruce", "B · Impulso"]
const CYCLE_OUTPUT = "res://../trabajo/arte/revisiones/marcha_ciclo_derecho_v1/"
const CYCLE_SOURCES = ["contacto_identidad_v1", "contacto_apoyo_v3", "apoyo_v1", "apoyo_cruce_v1", "cruce_v1", "cruce_impulso_v7", "impulso_v2", "impulso_a_contacto_b_v3", "contacto_b_v4", "contacto_b_apoyo_b_v1", "apoyo_b_v2", "apoyo_b_cruce_b_v3", "cruce_b_v6", "cruce_b_impulso_b_v2", "impulso_b_v4", "impulso_b_contacto_a_v2"]
const CYCLE_NAMES = ["V7 original · reposo", "01 · Contacto A", "02 · Carga A", "03 · Apoyo A", "04 · Despegue A", "05 · Cruce A", "06 · Extensión A", "07 · Impulso A", "08 · Llegada B", "09 · Contacto B", "10 · Carga B", "11 · Apoyo B", "12 · Despegue B", "13 · Cruce B", "14 · Extensión B", "15 · Impulso B", "16 · Llegada A"]


func check() -> void:
	var with_cycle := "--ciclo-derecho" in OS.get_cmdline_user_args()
	var with_second := "--segundo-paso" in OS.get_cmdline_user_args()
	var with_sleeves := "--mangas" in OS.get_cmdline_user_args()
	assert(not (with_second and with_sleeves), "Seleccionar una sola revisión")
	assert(not with_cycle or not (with_second or with_sleeves or "--intermedios" in OS.get_cmdline_user_args()), "Seleccionar una sola revisión")
	var with_inbetweens := "--intermedios" in OS.get_cmdline_user_args() or with_sleeves
	var sources: Array = INBETWEEN_SOURCES if with_inbetweens else SOURCES
	var names: Array = INBETWEEN_NAMES if with_inbetweens else NAMES
	var output: String = INBETWEEN_OUTPUT if with_inbetweens else OUTPUT
	if with_sleeves:
		sources = INBETWEEN_SOURCES.duplicate()
		sources[5] = "cruce_impulso_v7"
		sources[6] = "impulso_v2"
		output = SLEEVE_OUTPUT
	if with_second:
		sources = SECOND_SOURCES
		names = SECOND_NAMES
		output = SECOND_OUTPUT
	if with_cycle:
		sources = CYCLE_SOURCES
		names = CYCLE_NAMES
		output = CYCLE_OUTPUT
		assert(sources.size() == 16 and names.size() == 17)
	assert(names.size() == sources.size() + 1)
	var images: Array[Image] = [preload("res://assets/personajes/sota/perfiles_pixel_v7.png").get_image()]
	var measures: Array[Dictionary] = [measure(images[0], Rect2i(0, 0, 768, 1024))]
	var tonal_failures: Array[String] = []
	for source in sources:
		var image := Image.load_from_file(ProjectSettings.globalize_path("res://../trabajo/arte/personajes/sota/caminar_v2/" + source + ".png"))
		assert(image != null and image.get_size() == Vector2i(1536, 1024))
		assert(image.get_pixel(0, 0).a == 0.0 and image.get_pixel(1535, 1023).a == 0.0)
		var measured := measure(image, Rect2i(768, 0, 768, 1024))
		var r: Array = measured.region
		assert(r[0] > 768 and r[0] + r[2] < 1536 and r[1] > 0 and r[1] + r[3] < 1024)
		assert(r[3] > 820 and r[3] < 900)
		var ratio: float = measured.luminancia_srgb_media / measures[0].luminancia_srgb_media
		if not (ratio > 0.8 and ratio < 1.15):
			tonal_failures.append(source)
		images.append(image)
		measures.append(measured)
	var file := FileAccess.open(output + "medidas.json", FileAccess.WRITE)
	assert(file != null)
	var report := {"nombres": names, "medidas": measures, "escala_comun": 252.0 / 871.0, "nota": "RGB sRGB codificado sobre alfa >= 0.95; promedio afectado por forma y cobertura. No prueba identidad, paleta exacta ni aprobación. Encuadre estático por contorno; pivote de locomoción pendiente."}
	if with_cycle:
		report["alertas_tonales"] = tonal_failures
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	if DisplayServer.get_name() != "headless" and "--capturas" in OS.get_cmdline_user_args():
		if with_cycle:
			for first in [1, 9]:
				await capture_series(images.slice(first, first + 8), measures.slice(first, first + 8), names.slice(first, first + 8), output + ("paso_a/" if first == 1 else "paso_b/"))
		else:
			await capture_series(images, measures, names, output)
		if with_sleeves:
			var comparison: Array[Image] = [images[0]]
			var comparison_measures: Array[Dictionary] = [measures[0]]
			for sample in [["cruce_impulso_v3", 6], ["impulso_v1", 7]]:
				var old := Image.load_from_file(ProjectSettings.globalize_path("res://../trabajo/arte/personajes/sota/caminar_v2/" + sample[0] + ".png"))
				comparison.append(old)
				comparison_measures.append(measure(old, Rect2i(768, 0, 768, 1024)))
				comparison.append(images[sample[1]])
				comparison_measures.append(measures[sample[1]])
			await capture_series(comparison, comparison_measures, ["V7 original", "Extensión · antes", "Extensión · manga", "Impulso · antes", "Impulso · manga"], output + "detalle/")
		if with_second:
			var comparison: Array[Image] = []
			var comparison_measures: Array[Dictionary] = []
			for sample in [["contacto_identidad_v1", 1], ["apoyo_v1", 2], ["cruce_v1", 3], ["impulso_v2", 4]]:
				var first := Image.load_from_file(ProjectSettings.globalize_path("res://../trabajo/arte/personajes/sota/caminar_v2/" + sample[0] + ".png"))
				comparison.append(first)
				comparison_measures.append(measure(first, Rect2i(768, 0, 768, 1024)))
				comparison.append(images[sample[1]])
				comparison_measures.append(measures[sample[1]])
			await capture_series(comparison, comparison_measures, ["A · Contacto", "B · Contacto", "A · Apoyo", "B · Apoyo", "A · Cruce", "B · Cruce", "A · Impulso", "B · Impulso"], output + "comparacion_pasos/")
	print("Poses oscuras: alfa, márgenes, dimensiones y altura comprobados. ", measures)
	if not tonal_failures.is_empty():
		push_error("Revisar desviación tonal: " + ", ".join(tonal_failures))
		quit(1)
	else:
		print("Rango tonal comprobado.")
		quit()


func capture_series(images: Array[Image], measures: Array[Dictionary], names: Array, output: String) -> void:
	assert(images.size() == measures.size() and images.size() == names.size())
	var with_inbetweens := images.size() == 8
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
		sprite.position = Vector2(130 + index * 200 if with_inbetweens else 350 + index * 250, 705)
		scene.add_child(sprite)
		sprites.append(sprite)
		var label := Label.new()
		label.text = names[index]
		label.position = Vector2(sprite.position.x - 80, 420)
		scene.add_child(label)
		labels.append(label)
	var picture := await frame(viewport)
	assert(picture.save_png(output + "comparacion_velvet.png") == OK)
	if with_inbetweens:
		viewport.size = Vector2i(1672, 1200)
	for index in range(sprites.size()):
		sprites[index].reparent(viewport)
		sprites[index].position = Vector2(209 + (index % 4) * 418, 580 + floori(index / 4.0) * 580) if with_inbetweens else Vector2(175 + index * 330, 820)
		sprites[index].scale *= 2.0
		labels[index].reparent(viewport)
		labels[index].position = sprites[index].position + Vector2(-80, -550) if with_inbetweens else Vector2(95 + index * 330, 245)
	scene.queue_free()
	picture = await frame(viewport)
	assert(picture.save_png(output + "comparacion_2x.png") == OK)
	viewport.queue_free()
	await process_frame
