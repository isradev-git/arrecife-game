extends "res://candidatas/sota_union_v21.gd"

func build(profile: int) -> void:
	super.build(profile)
	# El pantalón completo debe empezar bajo el cinturón, no a la altura de la entrepierna.
	for index in range(legs.size()):
		var leg: Dictionary = legs[index]
		var vertices: PackedVector2Array = leg.thigh.get_meta("original_polygon").duplicate()
		for i in range(vertices.size()):
			var source_y: float = (vertices[i].y+leg.hip.y)/pixel_scale+hip_source.y
			var front: bool = signf(vertices[i].x)==direction
			if absf(source_y-490.0)<0.01:
				vertices[i].y=(430.0-hip_source.y)*pixel_scale-leg.hip.y
				vertices[i].x=signf(vertices[i].x)*((22.0 if index==0 else 24.0) if front else 20.0)
			elif absf(source_y-530.0)<0.01:
				vertices[i].y=(490.0-hip_source.y)*pixel_scale-leg.hip.y
				vertices[i].x=signf(vertices[i].x)*((22.0 if index==0 else 24.0) if front else 14.0)
		leg.thigh.set_meta("original_polygon",vertices)
	# La cintura pasa por detrás del torso y del deck; las piernas mantienen sus planos cercano/lejano.
	parts.torso.z_index=2
	parts.head.z_index=3
	body.move_child(parts.torso,parts.deck.get_index()-1)
	pose(0.0)
