extends SceneTree
const RIG = preload("res://candidatas/sota_cintura_v22.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var error := 0.0
	var jump := 0.0
	var drift := 0.0
	var boot_angle := 0.0
	var crouched := 0
	var max_lean := 0.0
	for profile in range(2):
		var rig := RIG.new()
		root.add_child(rig)
		rig.build(profile)
		var before := Vector2.ZERO
		var start: Array = []
		var start_parts: Dictionary = {}
		var previous_feet := {}
		for sample in range(2049):
			var phase := sample/2048.0
			rig.pose(phase)
			max_lean=maxf(max_lean,absf(rad_to_deg(rig.parts.torso.rotation)))
			assert(rig.parts.torso.scale==Vector2.ONE)
			assert(absf(rig.parts.head.rotation)<=0.06001)
			if sample==0:
				start=rig.joints.duplicate(true)
				for node in [rig.parts.torso,rig.parts.head,rig.parts.deck,rig.arms[0].sleeve,rig.arms[0].hand,rig.arms[1].sleeve,rig.arms[1].hand]: start_parts[node]=node.transform
			else: jump=maxf(jump,rig.body.position.distance_to(before))
			before=rig.body.position
			for leg in rig.legs:
				var original: PackedVector2Array = leg.thigh.get_meta("original_polygon")
				var rendered: PackedVector2Array = leg.thigh.polygon
				for triangle in leg.thigh.polygons:
					var upper_band := true
					for corner in triangle:
						if (original[corner].y+leg.hip.y)/rig.pixel_scale+rig.hip_source.y>610.01: upper_band=false
					if upper_band:
						assert((rendered[triangle[1]]-rendered[triangle[0]]).cross(rendered[triangle[2]]-rendered[triangle[0]])>0.0001,"Cintura plegada o invertida")
			var minimum_flex := INF
			for i in range(2):
				var j: Array = rig.joints[i]
				minimum_flex=minf(minimum_flex,absf(rad_to_deg((j[1]-j[0]).angle_to(j[2]-j[1]))))
				boot_angle=maxf(boot_angle,absf(rad_to_deg(rig.legs[i].boot.rotation)))
				for point in j: assert(point.is_finite())
				error=maxf(error,absf(j[0].distance_to(j[1])-56))
				error=maxf(error,absf(j[1].distance_to(j[2])-56))
				assert(j[0].distance_to(j[2])<=112.0001)
				assert((j[2]-j[0]).cross(j[1]-j[0])*rig.direction<=0.0001)
				var p: float = rig.contacts[i].phase
				if p>=0.13 and p<=0.38:
					var contact_x: float = j[2].x+rig.direction*RIG.CYCLE_DISTANCE*phase
					if previous_feet.has(i): drift=maxf(drift,absf(contact_x-previous_feet[i]))
					previous_feet[i]=contact_x
				else: previous_feet.erase(i)
			if minimum_flex>25: crouched+=1
			if sample==2048:
				for node in start_parts: assert(node.transform.is_equal_approx(start_parts[node]),"Salto de pieza en cierre del ciclo")
				for i in range(2):
					for j in range(3): assert(rig.joints[i][j].distance_to(start[i][j])<0.0001)
		assert(jump<0.2,"Salto de pelvis entre submuestras")
		rig.queue_free()
	print("OK: cintura y muslo superior sin triángulos invertidos ni colapsados en las 4098 subposes.")
	assert(crouched==0,"Ambas rodillas flexionadas durante marcha")
	assert(boot_angle<35,"Bota excesivamente en punta")
	print("OK: ambas rodillas >25° en %d subposes; inclinación máxima de bota %.3f°." % [crouched,boot_angle])
	assert(max_lean<3.5,"Inclinación añadida excesiva")
	print("OK: inclinación máxima añadida del torso %.3f grados, sin escalado." % max_lean)
	assert(error<0.0001)
	assert(drift<0.0001)
	print("OK: 4098 poses; error de segmento %.8f px; salto de pelvis por 1/2048 %.6f px; deriva de apoyo plano por muestra %.8f px." % [error,jump,drift])
	quit()
