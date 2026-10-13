extends RefCounted

const DATA_PATH = "res://assets/personajes/sota/movimiento_v3/movimiento.json"
const CYCLE_DISTANCE = 224.0
const START_DISTANCE = 8.0
const SETTLE_TIME = 0.24

var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
var textures: Dictionary = {}
var profile := 0
var state := "reposo"
var frame_index := -1
var distance := 0.0
var start_distance := 0.0
var timer := 0.0
var reduced_motion := false
var closing_step := 0


func _init() -> void:
	assert(data.distancia_ciclo == CYCLE_DISTANCE)
	assert(data.perfiles.size() == 2)
	for view in data.perfiles:
		assert(view.marcha.size() == 16)
		assert(view.avance_poses.size() == 16 and view.avance_poses[0] == 0.0)
		for index in range(1, 16):
			assert(view.avance_poses[index] > view.avance_poses[index - 1] and view.avance_poses[index] < CYCLE_DISTANCE)
		for pose in view.marcha + [view.reposo, view.preparar, view.cerrar_a, view.cerrar_b, view.respirar]:
			var texture := AtlasTexture.new()
			texture.atlas = load(pose.archivo)
			assert(texture.atlas != null)
			texture.region = Rect2(pose.celda[0], 0, 836, 1024)
			texture.filter_clip = true
			textures[pose.archivo + str(pose.celda[0])] = texture


func frame_at(travel: float) -> int:
	var phase := fposmod(travel + CYCLE_DISTANCE / 4.0, CYCLE_DISTANCE)
	var centers: Array = data.perfiles[profile].avance_poses
	# Cada postura dura según el avance de su apoyo, no un dieciseisavo fijo del ciclo.
	# shortcut: las poses discretas aún deslizan el pie; redibujarlas si la revisión animada no es suficiente.
	for index in range(16):
		var next: float = centers[index + 1] if index < 15 else CYCLE_DISTANCE
		if phase < (float(centers[index]) + next) / 2.0:
			return index
	return 0


func reset(facing: int) -> void:
	profile = facing
	state = "reposo"
	frame_index = -1
	distance = 0.0
	start_distance = 0.0
	timer = 0.0


func update(sprite: Sprite2D, moved: float, delta: float, facing: int) -> void:
	var dt := clampf(delta, 0.0, 0.05)
	if absf(moved) > 0.0001:
		var direction := 1.0 if moved > 0.0 else -1.0
		var next_profile := 0 if direction > 0.0 else 1
		if profile != next_profile or state in ["reposo", "parada", "giro"]:
			reset(next_profile)
			state = "arranque"
		start_distance += absf(moved)
		if start_distance < START_DISTANCE:
			apply(sprite, data.perfiles[profile].preparar)
			return
		if state == "arranque":
			state = "marcha"
			distance = 0.0
		distance += absf(moved)
		frame_index = frame_at(distance)
		var view: Dictionary = data.perfiles[profile]
		var pose: Dictionary = view.marcha[frame_index]
		# El apoyo pertenece al dibujo; fijar el sprite completo congela la cadera entre poses.
		apply(sprite, pose)
		timer = 0.0
		return
	if state in ["marcha", "arranque"]:
		closing_step = 0 if frame_index < 8 else 1
		state = "parada"
		timer = 0.0
	if state == "parada":
		timer += dt
		apply(sprite, data.perfiles[profile].cerrar_a if closing_step == 0 else data.perfiles[profile].cerrar_b)
		if timer < SETTLE_TIME:
			return
		reset(profile)
	if facing != profile:
		reset(facing)
		state = "giro"
	if state == "giro":
		timer += dt
		apply(sprite, data.perfiles[profile].preparar)
		if timer < 0.12:
			return
		reset(profile)
	timer += dt
	var breathe := not reduced_motion and timer > 1.0 and fposmod(timer, 4.0) > 1.4 and fposmod(timer, 4.0) < 2.8
	apply(sprite, data.perfiles[profile].respirar if breathe else data.perfiles[profile].reposo)


func apply(sprite: Sprite2D, pose: Dictionary) -> void:
	sprite.texture = textures[pose.archivo + str(pose.celda[0])]
	sprite.centered = false
	sprite.offset = Vector2(-(pose.cadera_x - pose.celda[0]), -pose.suelo_y)
	sprite.scale = Vector2.ONE * float(data.perfiles[profile].escala)
	sprite.position = Vector2.ZERO
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
