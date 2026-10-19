extends "res://candidatas/sota_ik_v15.gd"

# La izquierda comparte la coordinación aprobada de la derecha; conserva sus propios recortes y equipo.
var capture: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/captura_v16_candidata/ciclo.json"))

func channel(name: String, phase: float) -> float:
	var coefficients: Array = capture.canales[name]
	var value: float = coefficients[0]
	for k in range(1,coefficients.size()):
		value += coefficients[k][0]*cos(k*phase*TAU)+coefficients[k][1]*sin(k*phase*TAU)
	return value

const CYCLE_DISTANCE = 140.0

func raw_leg(side: String, phase: float) -> Vector2:
	var upper := channel(side+"_muslo",phase)
	var lower := maxf(channel(side+"_tibia",phase),upper+0.015)
	return Vector2(cos(upper)+cos(lower),sin(upper)+sin(lower))*FEMUR

func foot_x(side: String, phase: float) -> float:
	var start := 0.11 if side=="l" else 0.61
	var p := fposmod(phase-start,1.0)
	var front := CYCLE_DISTANCE*0.3
	if p<=0.6: return front-CYCLE_DISTANCE*p
	var t := (p-0.6)/0.4
	var first := start+0.6
	var last := start+1.0
	var epsilon := 0.0001
	var a := -front-raw_leg(side,first).x
	var b := front-raw_leg(side,last).x
	var va := -CYCLE_DISTANCE-(raw_leg(side,first+epsilon).x-raw_leg(side,first-epsilon).x)/(2*epsilon)
	var vb := -CYCLE_DISTANCE-(raw_leg(side,last+epsilon).x-raw_leg(side,last-epsilon).x)/(2*epsilon)
	# Ajustar solo el desplazamiento de la captura; conservar el gesto de recuperación.
	return raw_leg(side,phase).x+(2*t*t*t-3*t*t+1)*a+(t*t*t-2*t*t+t)*0.4*va+(-2*t*t*t+3*t*t)*b+(t*t*t-t*t)*0.4*vb

func pose(phase: float, amount: float = 1.0) -> void:
	if legs.size()!=2 or arms.size()!=2: return
	pose_amount=amount
	joints.clear()
	contacts.clear()
	var low := -INF
	var hip_y: float = legs[1].hip.y
	for i in range(2):
		var side := "l" if i==0 else "r"
		var leg: Dictionary = legs[i]
		var p := fposmod(phase-(0.11 if side=="l" else 0.61),1.0)
		var tilt := (channel(side+"_bota",phase)-0.15)*0.45*direction
		# La suela permanece plana durante el apoyo medio; talón y punta ruedan en los extremos.
		var flat := smoothstep(0.03,0.13,p)*(1.0-smoothstep(0.38,0.56,p)) if p<0.6 else 0.0
		tilt*=1.0-flat
		var sole := -INF
		for point in leg.hull: sole=maxf(sole,point.rotated(tilt).y)
		var raw := raw_leg(side,phase)
		var bottom := hip_y+raw.y+sole
		low=maxf(low,bottom)
		contacts.append({"bottom":bottom,"phase":p,"sole":sole,"angle":tilt,"side":side})
	var pelvis_y := -low
	var preferred := 0.0
	var support_weight := 0.0
	var limits: Array[float] = []
	for i in range(2):
		var contact: Dictionary = contacts[i]
		var p: float = contact.phase
		var lift := maxf(0,low-float(contact.bottom))
		if p<0.6: lift=0.0
		else: lift*=smoothstep(0.6,0.66,p)*(1.0-smoothstep(0.94,1.0,p))
		var ankle := Vector2(direction*foot_x(contact.side,phase),-float(contact.sole)-lift)
		contact["ankle"]=ankle
		contact["lift"]=lift
		var hip_x := direction*(2.0 if i==0 else 0.0)
		var dx := ankle.x-hip_x
		var limit := ankle.y-hip_y-sqrt(REACH*REACH-dx*dx)
		limits.append(limit)
		var weight := smoothstep(0.0,0.08,p)*(1.0-smoothstep(0.48,0.6,p)) if p<0.6 else 0.0
		var flex := deg_to_rad(8)+deg_to_rad(10)*smoothstep(0.0,deg_to_rad(30),channel(contact.side+"_tibia",phase)-channel(contact.side+"_muslo",phase))
		var support_reach := 2*FEMUR*cos(flex*0.5)
		preferred+=(ankle.y-hip_y-sqrt(support_reach*support_reach-dx*dx))*weight
		support_weight+=weight
	if support_weight>0: pelvis_y=preferred/support_weight
	for limit in limits: pelvis_y=smooth_max(pelvis_y,limit)
	body.position=Vector2(-legs[1].hip.x,pelvis_y)
	for i in range(2):
		var leg: Dictionary = legs[i]
		var hip := Vector2(legs[1].hip.x+direction*(2.0 if i==0 else 0.0),hip_y)
		var ankle: Vector2 = contacts[i].ankle-body.position
		var axis := ankle-hip
		var along := axis.length()*0.5
		var knee := hip+axis*0.5+Vector2(axis.normalized().y,-axis.normalized().x)*direction*sqrt(maxf(0,FEMUR*FEMUR-along*along))
		leg.thigh.position=hip
		leg.thigh.rotation=(knee-hip).angle()-leg.thigh_angle
		leg.shin.position=knee
		leg.shin.rotation=(ankle-knee).angle()-leg.shin_angle
		leg.boot.position=ankle
		leg.boot.rotation=contacts[i].angle
		deform_leg(leg,hip,knee,ankle)
		joints.append([hip,knee,ankle])
	var pixel_offset := body.position.round()-body.position
	var lean := (0.14+(channel("tronco",phase)-float(capture.canales.tronco[0]))*0.5)*direction
	parts.torso.position=Vector2(0,-124)+pixel_offset
	parts.torso.rotation=lean
	var neck := Vector2(-12*direction,-80)
	parts.head.position=neck.rotated(lean)-neck+pixel_offset
	parts.deck.rotation=lean
	parts.deck.position=Vector2(0,-124)-Vector2(0,-124).rotated(lean)+pixel_offset
	for i in range(2):
		for j in range(3): joints[i][j]+=body.position
		var side := "l" if i==0 else "r"
		var arm: Dictionary = arms[i]
		var shoulder: Vector2 = arms[1].shoulder+Vector2(direction*(2 if i==0 else 0),0)
		shoulder=(shoulder-Vector2(0,-124)).rotated(lean)+Vector2(0,-124)+pixel_offset
		var upper := PI/2+(channel(side+"_brazo",phase)-PI/2)*0.75
		var lower := PI/2+(channel(side+"_antebrazo",phase)-PI/2)*0.75
		var elbow: Vector2 = shoulder+Vector2(cos(upper)*direction,sin(upper))*arm.upper_length
		arm.sleeve.position=shoulder
		arm.sleeve.rotation=Vector2(cos(upper)*direction,sin(upper)).angle()-arm.sleeve_angle
		arm.hand.position=elbow
		arm.hand.rotation=Vector2(cos(lower)*direction,sin(lower)).angle()-arm.hand_angle

func build(profile: int) -> void:
	super.build(profile)
	# La unión ya está cubierta por los muslos; esta pieza aplanaba los pliegues debajo de la cintura.
	parts.pelvis.hide()
	if profile==1:
		# La cintura muestreaba solo 22 px de tela limpia; recuperar también la costura y su sombra.
		for leg in legs:
			var uv: PackedVector2Array = leg.thigh.uv
			for i in range(uv.size()):
				if uv[i].y<500: uv[i].x=1000+(uv[i].x-1018)*2
			leg.thigh.uv=uv
	pose(0.0)

func cloth_point(leg: Dictionary, source: Vector2, hip: Vector2, knee: Vector2, ankle: Vector2) -> Vector2:
	var upper: Vector2 = hip+stretched(source-leg.hip,leg.thigh_axis,(knee-hip).length()).rotated(leg.thigh.rotation)
	var lower: Vector2 = knee+stretched(source-leg.neutral_knee,leg.shin_axis,(ankle-knee).length()).rotated(leg.shin.rotation)
	var cloth := upper.lerp(lower,smoothstep(leg.neutral_knee.y-9,leg.neutral_knee.y+9,source.y))
	var waist := (490.0-hip_source.y)*pixel_scale
	# El bolsillo queda fuera de la transición de cintura y conserva el ancho de su dibujo.
	cloth=source.lerp(cloth,smoothstep(waist,waist+18,source.y))
	var foot: Vector2 = ankle+(source-leg.neutral_ankle).rotated(leg.boot.rotation)
	# La caña acompaña a la bota, sin estirar sus correas con toda la tibia.
	return cloth.lerp(foot,smoothstep(leg.neutral_ankle.y-28,leg.neutral_ankle.y-18,source.y))
