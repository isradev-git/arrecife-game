extends SceneTree
const RIG = preload("res://candidatas/sota_captura_v16.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var error := 0.0
	var jump := 0.0
	var drift := 0.0
	for profile in range(2):
		var rig := RIG.new()
		root.add_child(rig)
		rig.build(profile)
		var before := Vector2.ZERO
		var start: Array = []
		var previous_feet := {}
		for sample in range(2049):
			var phase := sample/2048.0
			rig.pose(phase)
			if sample==0: start=rig.joints.duplicate(true)
			else: jump=maxf(jump,rig.body.position.distance_to(before))
			before=rig.body.position
			for i in range(2):
				var j: Array = rig.joints[i]
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
			if sample==2048:
				for i in range(2):
					for j in range(3): assert(rig.joints[i][j].distance_to(start[i][j])<0.0001)
		assert(jump<0.2,"Salto de pelvis entre submuestras")
		rig.queue_free()
	assert(error<0.0001)
	assert(drift<0.0001)
	print("OK: 4098 poses; error de segmento %.8f px; salto de pelvis por 1/2048 %.6f px; deriva de apoyo plano por muestra %.8f px." % [error,jump,drift])
	quit()
