extends RefCounted

const DATA_PATH = "res://assets/personajes/sota/articulada_v4/movimiento.json"
const CYCLE_DISTANCE = 128.0
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
var closing_frame := 8

func _init() -> void:
	assert(data.distancia_ciclo == CYCLE_DISTANCE and data.perfiles.size() == 2)
	for view in data.perfiles:
		assert(view.marcha.size() == 32 and view.arranque.size() == 4 and view.cierres.size() == 32)
		var poses: Array = view.marcha + view.arranque + view.respiracion + [view.reposo]
		for closing in view.cierres:
			assert(closing.size() == 4)
			poses += closing
		for pose in poses:
			var texture := AtlasTexture.new()
			texture.atlas = load(pose.archivo)
			assert(texture.atlas != null)
			texture.region = Rect2(pose.celda[0],pose.celda[1],pose.celda[2],pose.celda[3])
			texture.filter_clip=true
			textures[key(pose)] = texture

func key(pose: Dictionary) -> String:
	return pose.archivo + str(pose.celda)

func frame_at(travel: float) -> int:
	return posmod(roundi(travel / (CYCLE_DISTANCE/32.0)) + 8,32)

func reset(facing: int) -> void:
	profile=facing
	state="reposo"
	frame_index=-1
	distance=0.0
	start_distance=0.0
	timer=0.0

func update(sprite: Sprite2D, moved: float, delta: float, facing: int) -> void:
	var dt:=clampf(delta,0.0,0.05)
	if absf(moved)>0.0001:
		var next_profile:=0 if moved>0.0 else 1
		if profile!=next_profile or state in ["reposo","parada","giro"]:
			reset(next_profile)
			state="arranque"
		start_distance+=absf(moved)
		distance+=absf(moved)
		if start_distance<START_DISTANCE:
			apply(sprite,data.perfiles[profile].arranque[mini(3,int(start_distance/START_DISTANCE*4.0))])
			return
		state="marcha"
		frame_index=frame_at(distance)
		apply(sprite,data.perfiles[profile].marcha[frame_index])
		timer=0.0
		return
	if state in ["marcha","arranque"]:
		closing_frame=frame_index if frame_index>=0 else frame_at(distance)
		state="parada"
		timer=0.0
	if state=="parada":
		timer+=dt
		if timer<SETTLE_TIME:
			apply(sprite,data.perfiles[profile].cierres[closing_frame][mini(3,int(timer/SETTLE_TIME*4.0))])
			return
		reset(profile)
	if facing!=profile:
		reset(facing)
		state="giro"
	if state=="giro":
		timer+=dt
		apply(sprite,data.perfiles[profile].reposo)
		if timer<0.12: return
		reset(profile)
	timer+=dt
	var breath:=fposmod(timer,4.0)
	if not reduced_motion and timer>1.0 and breath>1.0 and breath<3.0:
		apply(sprite,data.perfiles[profile].respiracion[mini(3,int((breath-1.0)*2.0))])
	else:
		apply(sprite,data.perfiles[profile].reposo)

func current_pose() -> Dictionary:
	var view: Dictionary = data.perfiles[profile]
	if state=="marcha": return view.marcha[frame_index]
	if state=="arranque": return view.arranque[mini(3,int(start_distance/START_DISTANCE*4.0))]
	if state=="parada": return view.cierres[closing_frame][mini(3,int(timer/SETTLE_TIME*4.0))]
	return view.reposo

func apply(sprite: Sprite2D, pose: Dictionary) -> void:
	sprite.texture=textures[key(pose)]
	sprite.centered=false
	sprite.offset=Vector2(-(pose.cadera_x-pose.celda[0]),-(pose.suelo_y-pose.celda[1]))
	sprite.scale=Vector2.ONE
	sprite.position=Vector2.ZERO
	sprite.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
