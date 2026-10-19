extends "res://candidatas/sota_union_v21.gd"

const HIP_FORWARD = 8.0

func build(profile: int) -> void:
	super.build(profile)
	# La pelvis conserva su borde trasero aunque el fémur nazca más adelante dentro de ella.
	for index in range(legs.size()):
		var leg: Dictionary = legs[index]
		var vertices: PackedVector2Array = leg.thigh.get_meta("original_polygon").duplicate()
		for i in range(vertices.size()):
			var source_y: float = (vertices[i].y+leg.hip.y)/pixel_scale+hip_source.y
			if absf(source_y-490.0)<0.01 or absf(source_y-530.0)<0.01:
				var front: bool = signf(vertices[i].x)==direction
				vertices[i].x=signf(vertices[i].x)*((12.0 if index==0 else 14.0) if front else (24.0 if index==0 else 22.0))
		leg.thigh.set_meta("original_polygon",vertices)
	pose(0.0)

func pose(phase: float, amount: float = 1.0) -> void:
	super.pose(phase,amount)
	if legs.size()!=2 or arms.size()!=2: return
	var old_pixel_offset := body.position.round()-body.position
	var hip_y: float = legs[1].hip.y
	var preferred := 0.0
	var support_weight := 0.0
	var limits: Array[float] = []
	for i in range(2):
		var contact: Dictionary = contacts[i]
		var ankle: Vector2 = contact.ankle
		var hip_x := direction*(HIP_FORWARD+(2.0 if i==0 else 0.0))
		var dx := ankle.x-hip_x
		limits.append(ankle.y-hip_y-sqrt(REACH*REACH-dx*dx))
		var p: float = contact.phase
		var weight := smoothstep(0.0,0.08,p)*(1.0-smoothstep(0.48,0.6,p)) if p<0.6 else 0.0
		var flex := deg_to_rad(8)+deg_to_rad(10)*smoothstep(0.0,deg_to_rad(30),channel(contact.side+"_tibia",phase)-channel(contact.side+"_muslo",phase))
		var support_reach := 2*FEMUR*cos(flex*0.5)
		preferred+=(ankle.y-hip_y-sqrt(support_reach*support_reach-dx*dx))*weight
		support_weight+=weight
	var pelvis_y := preferred/support_weight
	for limit in limits: pelvis_y=smooth_max(pelvis_y,limit)
	body.position.y=pelvis_y
	# El cuerpo conserva su postura; compensar únicamente el redondeo de su nueva altura de apoyo.
	var pixel_delta := body.position.round()-body.position-old_pixel_offset
	for node in [parts.torso,parts.head,parts.deck]: node.position+=pixel_delta
	for arm in arms:
		arm.sleeve.position+=pixel_delta
		arm.hand.position+=pixel_delta
	joints.clear()
	for i in range(2):
		var leg: Dictionary = legs[i]
		# La cabeza del fémur queda bajo el centro de la pelvis, delante del anclaje posterior anterior.
		var hip := Vector2(legs[1].hip.x+direction*(HIP_FORWARD+(2.0 if i==0 else 0.0)),hip_y)
		var ankle: Vector2 = contacts[i].ankle-body.position
		var axis := ankle-hip
		var knee := hip+axis*0.5+Vector2(axis.normalized().y,-axis.normalized().x)*direction*sqrt(maxf(0,FEMUR*FEMUR-axis.length_squared()*0.25))
		leg.thigh.position=hip
		leg.thigh.rotation=(knee-hip).angle()-leg.thigh_angle
		leg.shin.position=knee
		leg.shin.rotation=(ankle-knee).angle()-leg.shin_angle
		leg.boot.position=ankle
		leg.boot.rotation=contacts[i].angle
		deform_leg(leg,hip,knee,ankle)
		joints.append([hip+body.position,knee+body.position,ankle+body.position])
