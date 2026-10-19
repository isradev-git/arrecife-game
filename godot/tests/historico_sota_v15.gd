extends SceneTree
func _initialize() -> void:
	for entry in [["v4","res://../trabajo/arte/revisiones/modelo_marcha_v5/articulacion_antes.gd.txt"],["Modelo 8","res://../trabajo/arte/revisiones/modelo_marcha_v9/articulacion_antes.gd.txt"],["Modelo 14","res://sota_articulada.gd"]]:
		var script=GDScript.new()
		script.source_code=FileAccess.get_file_as_string(entry[1])
		assert(script.reload()==OK)
		for profile in range(2):
			var rig=script.new()
			root.add_child(rig)
			rig.build(profile)
			var minimum:=Vector2(INF,INF)
			var maximum:=Vector2.ZERO
			var reach:=0.0
			var unreachable:=0
			for frame in range(32):
				rig.pose(frame/32.0)
				for leg in rig.legs:
					var lengths:=Vector2(leg.thigh.position.distance_to(leg.shin.position),leg.shin.position.distance_to(leg.boot.position))
					minimum=Vector2(minf(minimum.x,lengths.x),minf(minimum.y,lengths.y))
					maximum=Vector2(maxf(maximum.x,lengths.x),maxf(maximum.y,lengths.y))
					var r:float=leg.thigh.position.distance_to(leg.boot.position)
					reach=maxf(reach,r)
					if r>112.0: unreachable+=1
			print("%s perfil%d · fémur/tibia mín %s máx %s · alcance %.4f · inalcanzables %d/64" % [entry[0],profile,minimum,maximum,reach,unreachable])
			rig.free()
	quit()
