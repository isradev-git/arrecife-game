extends SceneTree
const OLD = preload("res://candidatas/sota_postura_v19.gd")
const NEW = preload("res://candidatas/sota_pelvis_v20.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var excursions := [0.0,0.0]
	var inverted := [{},{}]
	for profile in range(2):
		for version in range(2):
			var rig = [OLD,NEW][version].new()
			root.add_child(rig)
			rig.build(profile)
			var points := {}
			for frame in range(257):
				rig.pose(frame/256.0)
				for leg_index in range(2):
					var leg: Dictionary = rig.legs[leg_index]
					var vertices: PackedVector2Array = leg.thigh.polygon
					for triangle in leg.thigh.polygons:
						var area := (vertices[triangle[1]]-vertices[triangle[0]]).cross(vertices[triangle[2]]-vertices[triangle[0]])
						if area<=0.0001:
							inverted[version]["%d/%d/%d/%s" % [profile,frame,leg_index,triangle]]=area
					var originals: PackedVector2Array = leg.thigh.get_meta("original_polygon")
					for index in range(originals.size()):
						var source: Vector2 = originals[index]+leg.hip
						if absf(source.y-(530.0-rig.hip_source.y)*rig.pixel_scale)>0.01: continue
						# Medir vértices de la malla final, relativos a la pelvis, no solo la función de deformación.
						var point: Vector2 = leg.thigh.transform*leg.thigh.polygon[index]
						var key := Vector2i(leg_index,index)
						if not points.has(key): points[key]=[]
						points[key].append(point)
			for samples in points.values():
				for a in samples:
					for b in samples: excursions[version]=maxf(excursions[version],a.distance_to(b))
			assert(not points.is_empty())
			rig.free()
	assert(inverted[0]==inverted[1],"Inversión de malla nueva")
	print("Límite heredado: %d inversiones de triángulos bajo la rodilla, idénticas antes/después; ninguna nueva." % inverted[1].size())
	assert(excursions[0]>1.0,"La muestra anterior debe reproducir el arrastre del tiro")
	assert(excursions[1]<0.0001,"El tiro se desplaza respecto a la pelvis")
	print("OK: desplazamiento máximo de vértices del tiro respecto a pelvis, 19 %.6f px → 20 %.6f px." % excursions)
	quit()
