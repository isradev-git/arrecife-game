extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var previous: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/captura_v17_candidata/movimiento.json"))
	var revised: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/captura_v18_candidata/movimiento.json"))
	var before := Image.load_from_file(ProjectSettings.globalize_path(previous.perfiles[0].marcha[0].archivo))
	var after := Image.load_from_file(ProjectSettings.globalize_path(revised.perfiles[0].marcha[0].archivo))
	var source := Image.load_from_file(ProjectSettings.globalize_path("res://assets/personajes/sota/perfiles_pixel_v7.png")).get_data()
	var palette: Dictionary = {}
	for i in range(0,source.size(),4):
		if source[i+3]>=242: palette[int(source[i])|(int(source[i+1])<<8)|(int(source[i+2])<<16)]=true
	var pixels := after.get_data()
	for i in range(0,pixels.size(),4):
		assert(pixels[i+3] in [0,255],"Alfa no binaria")
		if pixels[i+3]==255: assert(palette.has(int(pixels[i])|(int(pixels[i+1])<<8)|(int(pixels[i+2])<<16)),"Color ajeno a v7")
	print("OK: paleta original v7 y alfa binaria en todo el atlas.")
	var largest := 0
	var broken := 0
	for profile in range(2):
		for frame in range(64):
			var pose: Dictionary = revised.perfiles[profile].marcha[frame]
			var old: Dictionary = previous.perfiles[profile].marcha[frame]
			if profile==0:
				for key in ["articulaciones","pelvis","elevacion_suelas","celda","cadera_x","suelo_y"]: assert(pose[key]==old[key],"Cambio en la marcha derecha aprobada: "+key)
			var origin := Vector2i(pose.celda[0],pose.celda[1])
			var cell := after.get_region(Rect2i(origin,Vector2i(192,288)))
			if profile==0:
				for y in range(125):
					for x in range(192): assert(cell.get_pixel(x,y)==before.get_pixel(origin.x+x,origin.y+y),"Cambio en cabeza/chaqueta derecha")
			var waist := Vector2(96,272)+Vector2(pose.pelvis[0],pose.pelvis[1])+Vector2(0,-127)
			for y in range(-3,4):
				for x in range(-4,5): assert(cell.get_pixel(roundi(waist.x)+x,roundi(waist.y)+y).a>0.95,"Hueco en cintura")
			var mask := BitMap.new()
			mask.create_from_image_alpha(cell,0.95)
			var visited := BitMap.new()
			visited.create(Vector2i(192,288))
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
			largest=maxi(largest,detached)
			if detached>=8:
				broken+=1
				print("Separación perfil %d fase %d: %d píxeles" % [profile,frame,detached])
	print("128 poses: %d con fragmentos >=8 px, mayor fragmento %d px." % [broken,largest])
	assert(broken==0,"Pieza de ropa separada")
	print("OK: marcha y cabeza/chaqueta derechas idénticas a 17; cintura cubierta; sin piezas separadas >=8 px.")
	quit()
