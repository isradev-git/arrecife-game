extends "res://tests/identidad_marcha.gd"

const SOURCE = "res://../trabajo/arte/personajes/sota/"
const DEST = "res://assets/personajes/sota/movimiento_v3/"
const PHASES = ["contacto_a", "carga_a", "apoyo_a", "despegue_a", "cruce_a", "extension_a", "impulso_a", "llegada_b", "contacto_b", "carga_b", "apoyo_b", "despegue_b", "cruce_b", "extension_b", "impulso_b", "llegada_a"]
const RIGHT = ["contacto_identidad_v1", "contacto_apoyo_v3", "apoyo_v1", "apoyo_cruce_v1", "cruce_v1", "cruce_impulso_v7", "impulso_v2", "impulso_a_contacto_b_v8", "contacto_b_v4", "contacto_b_apoyo_b_v1", "apoyo_b_v2", "apoyo_b_cruce_b_v3", "cruce_b_v6", "cruce_b_impulso_b_v2", "impulso_b_v4", "impulso_b_contacto_a_v2"]
const LEFT_VERSIONS = [1, 1, 1, 3, 1, 3, 3, 3, 2, 2, 3, 3, 1, 1, 2, 1]
# Distancia de cada postura, calibrada con la puntera respecto a la cadera; dos pasos de 112 px.
const POSE_TRAVEL = [[0, 7, 14, 33, 61, 80, 98, 105, 112, 119, 126, 131, 158, 190, 203, 216], [0, 12, 18, 36, 61, 84, 98, 105, 112, 118, 124, 136, 169, 195, 205, 216]]


func check() -> void:
	var profiles: Array = []
	for profile in range(2):
		var frames: Array = []
		for index in range(16):
			var source: String = SOURCE + ("caminar_v2/" + RIGHT[index] if profile == 0 else "movimiento_v3/izquierda_" + PHASES[index] + "_v" + str(LEFT_VERSIONS[index])) + ".png"
			var destination: String = DEST + ("derecha_" if profile == 0 else "izquierda_") + PHASES[index] + ".png"
			copy(source, destination)
			var forward_support := (1 if profile == 0 else -1) if index in [0, 1, 2, 8, 9, 10] else 0
			frames.append(pose_data(destination, 700, true, forward_support, 1 if profile == 0 else -1))
		var view := {"escala": 252.0 / (871.0 if profile == 0 else 868.0), "marcha": frames, "avance_poses": POSE_TRAVEL[profile]}
		view["reposo"] = pose_data("res://assets/personajes/sota/perfiles_pixel_v7.png", 0 if profile == 0 else 700, false)
		view["escala"] = 252.0 / float(view.reposo.limites[3])
		for transition in ["preparar", "cerrar_a", "cerrar_b", "respirar"]:
			var destination: String = DEST + transition + ".png"
			if profile == 0:
				copy(SOURCE + "movimiento_v3/" + transition + "_v1.png", destination)
			view[transition] = pose_data(destination, 0 if profile == 0 else 700, false)
		profiles.append(view)
	var file := FileAccess.open(DEST + "movimiento.json", FileAccess.WRITE)
	assert(file != null)
	file.store_string(JSON.stringify({"perfiles": profiles, "distancia_ciclo": 224.0, "fases": PHASES, "alfa_render": 0.95, "nota": "PNG originales completos; marco836x1024, misma escala por perfil, apoyo medido al alfa de render. Sin reflejo ni normalización por fotograma. Cadencia por avance_poses y cadera continua; no fijar todo el sprite al pie."}, "\t"))
	file.close()
	print("Metadatos y copias originales de 32 fases y 4 transiciones preparados.")
	quit()


func copy(source: String, destination: String) -> void:
	assert(FileAccess.file_exists(source), "Falta recurso: " + source)
	assert(DirAccess.copy_absolute(ProjectSettings.globalize_path(source), ProjectSettings.globalize_path(destination)) == OK)


func pose_data(path: String, cell_x: int, walking: bool, forward_support: int = 0, toe_direction: int = 0) -> Dictionary:
	var image := Image.load_from_file(ProjectSettings.globalize_path(path))
	assert(image != null and image.get_size() == Vector2i(1536, 1024))
	# Calibración técnica del atlas a la misma máscara que renderiza el juego.
	var min_x := cell_x + 836
	var max_x := cell_x
	var min_y := 1024
	var max_y := 0
	for y in range(1024):
		for x in range(cell_x, cell_x + 836):
			if image.get_pixel(x, y).a >= 0.95:
				min_x = mini(min_x, x)
				max_x = maxi(max_x, x)
				min_y = mini(min_y, y)
				max_y = maxi(max_y, y)
	assert(min_x > cell_x and max_x < cell_x + 835 and min_y > 0 and max_y < 1023)
	var hips: Array[float] = []
	for y in range(460, 486):
		var run_start := -1
		var best := Vector2i(0, 0)
		for x in range(cell_x, cell_x + 836):
			var color := image.get_pixel(x, y)
			var body := color.a >= 0.95 and not (color.r > 0.18 and color.r > color.g * 1.35 and color.g > color.b * 1.1)
			if body and run_start < 0:
				run_start = x
			if not body and run_start >= 0:
				if x - run_start > best.y:
					best = Vector2i(run_start, x - run_start)
				run_start = -1
		if best.y > 50:
			hips.append(best.x + best.y / 2.0)
	hips.sort()
	assert(not hips.is_empty(), "Revisar cadera: " + path)
	var hip := hips[hips.size() / 2]
	var support_y := max_y
	if forward_support != 0:
		support_y = 0
		for y in range(800, 1024):
			for x in range(cell_x, cell_x + 836):
				if (x - hip) * forward_support > 30.0 and image.get_pixel(x, y).a >= 0.95:
					support_y = maxi(support_y, y)
		assert(support_y > 800)
	var support := Vector2i(0, 0)
	var run_start := -1
	for x in range(cell_x, cell_x + 836):
		var boot := image.get_pixel(x, support_y - 3).a >= 0.95 and (forward_support == 0 or (x - hip) * forward_support > 30.0)
		if boot and run_start < 0:
			run_start = x
		if not boot and run_start >= 0:
			if x - run_start > support.y:
				support = Vector2i(run_start, x - run_start)
			run_start = -1
	assert(support.y > 4, "Revisar apoyo: " + path)
	var support_x := support.x + support.y / 2.0
	if walking:
		# La puntera proyectada es estable al pasar de talón a suela y a despegue.
		var pending: Array[Vector2i] = [Vector2i(int(support_x), support_y - 3)]
		var visited: Dictionary = {}
		var toe := int(support_x)
		while not pending.is_empty():
			var pixel: Vector2i = pending.pop_back()
			if pixel in visited or pixel.x < cell_x or pixel.x >= cell_x + 836 or pixel.y < support_y - 20 or pixel.y > support_y:
				continue
			visited[pixel] = true
			if image.get_pixelv(pixel).a < 0.95:
				continue
			toe = maxi(toe, pixel.x) if toe_direction > 0 else mini(toe, pixel.x)
			for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
				pending.append(pixel + offset)
		support_x = float(toe)
	return {"archivo": path, "celda": [cell_x, 0, 836, 1024], "cadera_x": hip, "suelo_y": support_y + 1, "apoyo_x": support_x, "limites": [min_x, min_y, max_x - min_x + 1, max_y - min_y + 1], "medida": measure(image, Rect2i(cell_x, 0, 836, 1024)), "marcha": walking}
