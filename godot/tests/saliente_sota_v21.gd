extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var old := Image.load_from_file(ProjectSettings.globalize_path("res://assets/personajes/sota/captura_v20_candidata/marcha.png"))
	var revised := Image.load_from_file(ProjectSettings.globalize_path("res://assets/personajes/sota/captura_v21_candidata/marcha.png"))
	var counts := [0,0]
	var retreat := [0,0]
	for frame in range(128):
		var profile := frame/64
		var origin := Vector2i(frame%8,frame/8)*Vector2i(192,288)
		var bounds := Rect2i(0,0,192,288)
		var after := BitMap.new()
		after.create_from_image_alpha(revised.get_region(Rect2i(origin,Vector2i(192,288))),0.95)
		var exterior := BitMap.new()
		exterior.create(Vector2i(192,288))
		var pending: Array[Vector2i] = [Vector2i.ZERO]
		exterior.set_bitv(Vector2i.ZERO,true)
		while not pending.is_empty():
			var point: Vector2i = pending.pop_back()
			for delta in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
				var next: Vector2i = point+delta
				if not bounds.has_point(next) or exterior.get_bitv(next) or after.get_bitv(next): continue
				exterior.set_bitv(next,true)
				pending.append(next)
		for y in range(125,180):
			var before_edge := -999
			var after_edge := -999
			for x in range(192):
				var before := old.get_pixel(origin.x+x,origin.y+y).a>0.95
				var visible := after.get_bit(x,y)
				if before: before_edge=maxi(before_edge,x if profile==0 else -x)
				if visible: after_edge=maxi(after_edge,x if profile==0 else -x)
				if before and not visible:
					counts[profile]+=1
					assert(exterior.get_bit(x,y),"El recorte abre un agujero interior")
			if before_edge>-999 and after_edge>-999: retreat[profile]=maxi(retreat[profile],before_edge-after_edge)
	for profile in range(2):
		assert(counts[profile]>0 and retreat[profile]>0,"El saliente visible no cambia")
		print("Perfil %d: %d píxeles exteriores retirados en 64 fases; reducción máxima del saliente %d px; ningún agujero interior nuevo." % [profile,counts[profile],retreat[profile]])
	quit()
