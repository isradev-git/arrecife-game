extends RefCounted

const DATA_PATH = "res://assets/personajes/sota/movimiento_v3/movimiento.json"
const CYCLE_DISTANCE = 196.0
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
var plant_step := -1
var plant_world_x := 0.0
var visual_offset := 0.0
var closing_step := 0


func _init() -> void:
	assert(data.distancia_ciclo == CYCLE_DISTANCE)
	assert(data.perfiles.size() == 2)
	for view in data.perfiles:
		assert(view.marcha.size() == 16)
		for pose in view.marcha + [view.reposo, view.preparar, view.cerrar_a, view.cerrar_b, view.respirar]:
			var texture := AtlasTexture.new()
			texture.atlas = load(pose.archivo)
			assert(texture.atlas != null)
			texture.region = Rect2(pose.celda[0], 0, 836, 1024)
			texture.filter_clip = true
			textures[pose.archivo + str(pose.celda[0])] = texture


func frame_at(travel: float) -> int:
	return floori(fposmod(travel + CYCLE_DISTANCE / 4.0, CYCLE_DISTANCE) / (CYCLE_DISTANCE / 16.0))


func reset(facing: int) -> void:
	profile = facing
	state = "reposo"
	frame_index = -1
	distance = 0.0
	start_distance = 0.0
	timer = 0.0
	plant_step = -1
	visual_offset = 0.0


func update(sprite: Sprite2D, world_x: float, moved: float, delta: float, facing: int) -> void:
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
		var step := floori((distance + CYCLE_DISTANCE / 4.0) / (CYCLE_DISTANCE / 2.0))
		var foot_offset: float = (pose.apoyo_x - pose.cadera_x) * view.escala
		if step != plant_step:
			plant_step = step
			plant_world_x = world_x + foot_offset
		visual_offset = plant_world_x - world_x - foot_offset
		apply(sprite, pose, visual_offset)
		timer = 0.0
		return
	if state in ["marcha", "arranque"]:
		closing_step = 0 if frame_index < 8 else 1
		state = "parada"
		timer = 0.0
	if state == "parada":
		timer += dt
		visual_offset = move_toward(visual_offset, 0.0, 100.0 * dt)
		apply(sprite, data.perfiles[profile].cerrar_a if closing_step == 0 else data.perfiles[profile].cerrar_b, visual_offset)
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


func apply(sprite: Sprite2D, pose: Dictionary, shift: float = 0.0) -> void:
	sprite.texture = textures[pose.archivo + str(pose.celda[0])]
	sprite.centered = false
	sprite.offset = Vector2(-(pose.cadera_x - pose.celda[0]), -pose.suelo_y)
	sprite.scale = Vector2.ONE * float(data.perfiles[profile].escala)
	sprite.position = Vector2(shift, 0.0)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
