extends "res://sota_articulada.gd"

const FEMUR = 56.0
const SHIN = 56.0
const REACH = 111.8
var contacts: Array = []
var joints: Array = []

func build(profile: int) -> void:
	super.build(profile)
	# La fila 885 del atlas no representa la misma altura de tobillo en las cuatro botas.
	for leg in legs:
		var sole := -INF
		for point in leg.hull: sole=maxf(sole,point.y)
		var offset := Vector2(0,18.0-sole)
		leg.neutral_ankle-=offset
		leg.shin_axis=leg.neutral_ankle-leg.neutral_knee
		leg.shin_angle=leg.shin_axis.angle()
		for i in range(leg.hull.size()): leg.hull[i]+=offset
		for node in [leg.boot]+leg.boot.get_children():
			if not node.has_meta("original_polygon"): continue
			var vertices: PackedVector2Array=node.get_meta("original_polygon")
			for i in range(vertices.size()): vertices[i]+=offset
			node.set_meta("original_polygon",vertices)
	pose(0.0)

# El máximo suave conserva alcanzabilidad sin un cambio brusco de derivada.
func smooth_max(a: float, b: float) -> float:
	return (a+b+sqrt((a-b)*(a-b)+0.04))*0.5

func foot(index: int, phase: float, amount: float) -> Dictionary:
	var leg: Dictionary = legs[index]
	var p := fposmod(phase+(0.5 if index==0 else 0.0),1.0)
	var x := 38.4-STRIDE*p
	var lift := 0.0
	var tilt := -0.10*(1.0-smoothstep(0.0,0.12,p))+0.20*smoothstep(0.42,0.6,p)
	var pivot_weight := smoothstep(0.12,0.42,p)
	if p>=0.6:
		var t := (p-0.6)/0.4
		var ease := t*t*(3.0-2.0*t)
		x=lerpf(-38.4,38.4,ease)-STRIDE*0.4*t*(1.0-t)*(1.0-2.0*t)
		lift=14.0*pow(sin(PI*t),2.0)
		tilt=lerpf(0.20,-0.10,ease)+0.10*pow(sin(PI*t),2.0)
		pivot_weight=1.0-ease
	var sole := -INF
	for point in leg.hull: sole=maxf(sole,point.y)
	var heel := Vector2(direction*INF,sole)
	var toe := Vector2(-direction*INF,sole)
	for point in leg.hull:
		if point.y>=sole-1.0:
			if direction*point.x<direction*heel.x: heel=point
			if direction*point.x>direction*toe.x: toe=point
	var pivot := heel.lerp(toe,pivot_weight)
	var angle := tilt*direction*amount
	var low := -INF
	for point in leg.hull: low=maxf(low,point.rotated(angle).y)
	var ankle := Vector2(direction*x+pivot.x-pivot.rotated(angle).x,-low-lift*amount)
	var weight := smoothstep(0.0,0.1,p)*(1.0-smoothstep(0.5,0.6,p)) if p<0.6 else 0.0
	return {"ankle":ankle,"angle":angle,"phase":p,"weight":weight,"lift":lift*amount}

func pose(phase: float, amount: float = 1.0) -> void:
	if legs.size()!=2: return
	pose_amount=amount
	contacts=[foot(0,phase,amount),foot(1,phase,amount)]
	var hips: Array[Vector2] = [Vector2(legs[1].hip.x+direction*3.0,legs[0].hip.y),legs[1].hip]
	var pelvis_x: float = -legs[1].hip.x+direction*0.6*sin(phase*TAU*2.0)*amount
	var lowest := -INF
	var preferred := 0.0
	var total := 0.0
	for i in range(2):
		var target: Vector2 = contacts[i].ankle
		var dx := target.x-hips[i].x-pelvis_x
		assert(absf(dx)<REACH,"Trayectoria horizontal inalcanzable")
		var limit := target.y-hips[i].y-sqrt(REACH*REACH-dx*dx)
		lowest=limit if i==0 else smooth_max(lowest,limit)
		var p: float = contacts[i].phase
		var flex := 8.0+7.0*pow(sin(PI*clampf(p/0.3,0.0,1.0)),2.0)
		var support_reach := 2.0*FEMUR*cos(deg_to_rad(flex)*0.5)
		var desired := target.y-hips[i].y-sqrt(support_reach*support_reach-dx*dx)
		var weight: float = lerpf(0.5,contacts[i].weight,amount)
		preferred+=desired*weight
		total+=weight
	body.position=Vector2(pelvis_x,smooth_max(preferred/total,lowest))
	var pixel_offset := body.position.round()-body.position
	parts.head.position=pixel_offset
	parts.deck.position=pixel_offset
	parts.torso.position=Vector2(0,-124)+pixel_offset
	parts.torso.rotation=direction*(0.008+0.012*sin((phase-0.08)*TAU))*amount
	joints.clear()
	for i in range(2):
		var leg: Dictionary = legs[i]
		var hip := hips[i]
		var ankle: Vector2 = contacts[i].ankle-body.position
		var axis := ankle-hip
		var reach := axis.length()
		assert(reach<=FEMUR+SHIN and reach>absf(FEMUR-SHIN))
		var along := (FEMUR*FEMUR-SHIN*SHIN+reach*reach)/(2.0*reach)
		var bend := sqrt(maxf(0.0,FEMUR*FEMUR-along*along))
		var unit := axis/reach
		var knee := hip+unit*along+Vector2(unit.y,-unit.x)*direction*bend
		leg.thigh.position=hip
		leg.thigh.rotation=(knee-hip).angle()-leg.thigh_angle
		leg.shin.position=knee
		leg.shin.rotation=(ankle-knee).angle()-leg.shin_angle
		leg.boot.position=ankle
		leg.boot.rotation=contacts[i].angle
		deform_leg(leg,hip,knee,ankle)
		joints.append([hip+body.position,knee+body.position,ankle+body.position])
		var arm: Dictionary = arms[i]
		var shoulder: Vector2 = (arm.shoulder if i==1 else arms[1].shoulder+Vector2(direction*3.0,2.0))+pixel_offset
		var p: float = contacts[i].phase
		var swing := cos(p*TAU)*0.25*direction
		var upper := lerp_angle(arm.sleeve_angle,PI/2.0+swing,amount)
		var elbow: Vector2 = shoulder+Vector2.from_angle(upper)*arm.upper_length
		var lower := lerp_angle(arm.hand_angle,upper-direction*(0.16+0.06*cos((p-0.04)*TAU)),amount)
		arm.sleeve.position=shoulder
		arm.sleeve.rotation=upper-arm.sleeve_angle
		arm.hand.position=elbow
		arm.hand.rotation=lower-arm.hand_angle
