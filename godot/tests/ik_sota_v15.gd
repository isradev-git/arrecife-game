extends SceneTree

func _initialize() -> void: call_deferred("check")

func check() -> void:
	var path := "res://candidatas/sota_ik_v15.gd"
	if "--actual" in OS.get_cmdline_user_args(): path="res://sota_articulada.gd"
	var script = load(path)
	if "--modelo8" in OS.get_cmdline_user_args():
		script=GDScript.new()
		script.source_code=FileAccess.get_file_as_string("res://../trabajo/arte/revisiones/modelo_marcha_v9/articulacion_antes.gd.txt")
		assert(script.reload()==OK)
	var failed := false
	for profile in range(2):
		var rig=script.new()
		root.add_child(rig)
		rig.build(profile)
		var error := Vector2.ZERO
		var reaches := 0
		var wrong := 0
		var max_reach := 0.0
		var min_y := INF
		var max_y := -INF
		var jump := 0.0
		var angle_jump := 0.0
		var previous: Array = []
		var previous_angles := [0.0,0.0]
		for amount in [0.0,0.125,0.25,0.5,0.75,1.0]:
			previous=[]
			for frame in range(1025):
				rig.pose(frame/1024.0,amount)
				if amount==1.0:
					min_y=minf(min_y,rig.body.position.y)
					max_y=maxf(max_y,rig.body.position.y)
				var current: Array = [rig.body.position]
				for i in range(2):
					var leg: Dictionary=rig.legs[i]
					var hip: Vector2=leg.thigh.position
					var knee: Vector2=leg.shin.position
					var ankle: Vector2=leg.boot.position
					error.x=maxf(error.x,absf(hip.distance_to(knee)-56.0))
					error.y=maxf(error.y,absf(knee.distance_to(ankle)-56.0))
					var reach := hip.distance_to(ankle)
					if reach>112.001: reaches+=1
					max_reach=maxf(max_reach,reach)
					if (ankle-hip).cross(knee-hip)*rig.direction>0.001: wrong+=1
					assert(hip.is_finite() and knee.is_finite() and ankle.is_finite())
					var angle := (knee-hip).angle_to(ankle-knee)
					if frame>0: angle_jump=maxf(angle_jump,absf(angle-previous_angles[i]))
					previous_angles[i]=angle
					current.append(knee+rig.body.position)
					current.append(ankle+rig.body.position)
				if not previous.is_empty():
					for i in range(current.size()): jump=maxf(jump,current[i].distance_to(previous[i]))
				previous=current
		print("Perfil %d · error fémur/tibia %s; inalcanzables %d; alcance %.4f; inversiones %d; pelvis %.3f..%.3f; salto subfase %.3f px / %.3f°" % [profile,error,reaches,max_reach,wrong,min_y,max_y,jump,rad_to_deg(angle_jump)])
		failed=failed or error.x>0.001 or error.y>0.001 or reaches>0 or wrong>0 or jump>1.0 or angle_jump>deg_to_rad(2.0)
		var raster_pelvis_jump := 0.0
		var raster_joint_jump := 0.0
		var first: Array = []
		previous=[]
		for frame in range(65):
			rig.pose(frame/64.0)
			var points: Array=[rig.body.position]
			for leg in rig.legs:
				points.append(leg.shin.position+rig.body.position)
				points.append(leg.boot.position+rig.body.position)
			if frame==0: first=points.duplicate()
			else:
				raster_pelvis_jump=maxf(raster_pelvis_jump,absf(points[0].y-previous[0].y))
				for i in range(1,points.size()): raster_joint_jump=maxf(raster_joint_jump,points[i].distance_to(previous[i]))
			if frame==64:
				for i in range(points.size()): assert(points[i].distance_to(first[i])<0.001,"Bucle discontinuo")
			previous=points
		print("64 dibujos: salto pelvis %.3f px; articulaciones %.3f px; bucle 1→0 idéntico." % [raster_pelvis_jump,raster_joint_jump])
		rig.free()
	quit(1 if failed else 0)
