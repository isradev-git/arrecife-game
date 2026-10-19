extends "res://movimiento_sota.gd"

const CANDIDATE_PATH = "res://assets/personajes/sota/articulada_v11_candidata/movimiento.json"
const STOP_TIME = 0.4
const START_TIME = 0.4
var phase_offset := 16

func _init() -> void:
	super(CANDIDATE_PATH,false)
	closing_frame=phase_offset

func frame_at(travel: float) -> int:
	return posmod(roundi(travel/(CYCLE_DISTANCE/data.fases))+phase_offset,int(data.fases))

func reset(facing: int) -> void:
	super(facing)
	phase_offset=int(data.fases)/4
	closing_frame=phase_offset

func turn(facing: int) -> void:
	var previous := current_pose()
	profile=facing
	var best := INF
	var selected := 0
	for phase in range(int(data.fases)):
		var pose := blended_pose(phase)
		var a := Vector2(previous.articulaciones[0][2][0],previous.articulaciones[0][2][1])
		var b := Vector2(previous.articulaciones[1][2][0],previous.articulaciones[1][2][1])
		var c := Vector2(pose.articulaciones[0][2][0],pose.articulaciones[0][2][1])
		var d := Vector2(pose.articulaciones[1][2][0],pose.articulaciones[1][2][1])
		var cost := minf(a.distance_squared_to(c)+b.distance_squared_to(d),a.distance_squared_to(d)+b.distance_squared_to(c))
		cost+=pow(previous.pelvis[1]-pose.pelvis[1],2.0)
		if cost<best:
			best=cost
			selected=phase
	phase_offset=selected
	closing_frame=selected
	frame_index=selected
	distance=0.0

func update(sprite: Sprite2D, moved: float, delta: float, facing: int) -> void:
	var dt := clampf(delta,0.0,0.05)
	var next_profile := (0 if moved>0.0 else 1) if absf(moved)>0.0001 else facing
	if profile!=next_profile: turn(next_profile)
	if absf(moved)>0.0001:
		distance+=absf(moved)
		blend=move_toward(blend,1.0,minf(absf(moved)/START_DISTANCE,dt/START_TIME))
		frame_index=frame_at(distance)
		closing_frame=frame_index
		state="marcha" if blend==1.0 else "arranque"
		timer=0.0
	else:
		blend=move_toward(blend,0.0,dt/STOP_TIME)
		state="parada" if blend>0.0 else "reposo"
		timer+=dt
	# El reposo conserva los pies de la última fase; reanudar no cambia a otra postura.
	apply(sprite,blended_pose(closing_frame))

func current_pose() -> Dictionary:
	return visible_pose if not visible_pose.is_empty() else data.perfiles[profile].cierres[closing_frame][-1]
