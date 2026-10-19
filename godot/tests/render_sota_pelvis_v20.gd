extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var image := Image.load_from_file(ProjectSettings.globalize_path("res://assets/personajes/sota/captura_v20_candidata/marcha.png"))
	assert(image.get_size()==Vector2i(1536,4608))
	var low_min := 1000
	var low_max := 0
	var heights := []
	var sole_positions := {}
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/captura_v20_candidata/movimiento.json"))
	for cell in range(128):
		var origin := Vector2i(cell%8,cell/8)*Vector2i(192,288)
		var top := 1000
		var bottom := 0
		for y in range(288):
			for x in range(192):
				var alpha := image.get_pixel(origin.x+x,origin.y+y).a
				assert(alpha==0 or alpha==1,"Alfa no binaria")
				if alpha>0:
					assert(x>0 and x<191 and y>0 and y<287,"Recorte en borde de celda")
					top=mini(top,y)
					bottom=maxi(bottom,y)
		low_min=mini(low_min,bottom)
		low_max=maxi(low_max,bottom)
		heights.append(bottom-top+1)
		var phase := (cell%64)/64.0
		if (phase>=0.25 and phase<=0.47) or (phase>=0.75 and phase<=0.97):
			var profile: int = cell/64
			var leg := (0 if phase<0.5 else 1)
			var ankle_x: float = data.perfiles[profile].marcha[cell%64].articulaciones[leg][2][0]+96
			var x_min := 192
			# Medir la bota que apoya; la otra puede rozar la última fila durante el despegue.
			for y in range(bottom-1,bottom+1):
				for x in range(maxi(0,int(ankle_x)-34),mini(192,int(ankle_x)+35)):
					if image.get_pixel(origin.x+x,origin.y+y).a>0: x_min=mini(x_min,x)
			assert(x_min<192)
			var key := profile*2+(0 if phase<0.5 else 1)
			if not sole_positions.has(key): sole_positions[key]=[]
			sole_positions[key].append(x_min+phase*140*(1 if profile==0 else -1))
	assert(low_min>=270 and low_max<=273,"Apoyo raster fuera del margen de 2 px")
	print("OK: 128 celdas; alfa binaria; ningún recorte. Suela raster y=%d..%d (origen 272). Altura visible %d..%d px." % [low_min,low_max,heights.min(),heights.max()])
	var max_drift := 0.0
	for positions in sole_positions.values(): max_drift=maxf(max_drift,float(positions.max())-float(positions.min()))
	assert(max_drift<=1.01,"Deriva de suela plana renderizada")
	print("OK: deriva raster máxima en cuatro apoyos planos %.3f px." % max_drift)
	var scene: Node = load("res://candidatas/comparacion_sota_pelvis_v20.tscn").instantiate()
	root.add_child(scene)
	for fps in [30,60,120]:
		scene.elapsed=0.0
		scene.paused=false
		scene.slow=false
		for tick in range(fps*8): scene._process(1.0/fps)
		assert(absf(scene.elapsed-8.0)<0.0001)
		scene.paused=true
		scene._process(1.0/fps)
		assert(absf(scene.elapsed-8.0)<0.0001)
		scene.paused=false
		scene.slow=true
		for tick in range(fps*4): scene._process(1.0/fps)
		assert(absf(scene.elapsed-9.0)<0.0001)
	print("OK: reproducción, pausa y cámara lenta a 30/60/120 Hz.")
	scene.paused=true
	scene.elapsed=16.0/64*140/104
	if DisplayServer.get_name()!="headless":
		for i in range(3): await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("../trabajo/arte/revisiones/sota_pelvis_v20/comparacion_nativa.png")
	print("OK: escena nativa cargada.")
	quit()
