extends SceneTree

func _initialize() -> void:
	var path: String = preload("res://movimiento_sota.gd").DATA_PATH
	if "--antes" in OS.get_cmdline_user_args(): path="res://assets/personajes/sota/articulada_v5/movimiento.json"
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	var images := {}
	var checked := 0
	var failures := 0
	var worst := 0
	for view in data.perfiles:
		var poses: Array = view.marcha+view.arranque+view.respiracion+[view.reposo]
		for closing in view.cierres: poses+=closing
		for pose in poses:
			if not images.has(pose.archivo): images[pose.archivo]=Image.load_from_file(ProjectSettings.globalize_path(pose.archivo))
			var cell: Image = images[pose.archivo].get_region(Rect2i(pose.celda[0],pose.celda[1],256,320))
			var mask := BitMap.new()
			mask.create_from_image_alpha(cell,0.95)
			var visited := BitMap.new()
			visited.create(Vector2i(256,320))
			var areas := []
			var bounds := cell.get_used_rect()
			for y in range(bounds.position.y,bounds.end.y):
				for x in range(bounds.position.x,bounds.end.x):
					var start := Vector2i(x,y)
					if not mask.get_bitv(start) or visited.get_bitv(start): continue
					var pending: Array[Vector2i] = [start]
					visited.set_bitv(start,true)
					var area := 0
					while not pending.is_empty():
						var point: Vector2i = pending.pop_back()
						area+=1
						for dy in range(-1,2):
							for dx in range(-1,2):
								var next := point+Vector2i(dx,dy)
								if not bounds.has_point(next) or visited.get_bitv(next) or not mask.get_bitv(next): continue
								visited.set_bitv(next,true)
								pending.append(next)
					areas.append(area)
			areas.sort()
			var detached: int = areas[-2] if areas.size()>1 else 0
			worst=maxi(worst,detached)
			if detached>=8:
				failures+=1
				print("Pieza separada: ",pose.archivo," ",pose.celda," área ",detached)
			checked+=1
	print("Integridad: %d poses, %d con piezas separadas de 8 px o más; mayor fragmento %d px." % [checked,failures,worst])
	quit(1 if failures else 0)
