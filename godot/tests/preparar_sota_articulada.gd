extends SceneTree

const RIG = preload("res://sota_articulada.gd")
const OUTPUT = "res://assets/personajes/sota/articulada_v6/"
const CELL = Vector2i(256,320)
const FLOOR = Vector2(128,300)
var data := {"distancia_ciclo":128.0,"fases":32,"perfiles":[],"fuente":"res://assets/personajes/sota/perfiles_pixel_v7.png","fuente_piernas":"res://assets/personajes/sota/articulada_v6/piernas_separadas_intento1.png","nota":"Torso/cabeza/brazos v7; cuatro piezas independientes de pierna y bota con bolsillo fijo en la pierna cercana. Textura de piernas oscurecida de modo constante durante el horneado. Escala de juego fija, no normalización por pose."}

func _initialize() -> void:
	call_deferred("check")

func check() -> void:
	assert(DisplayServer.get_name() != "headless", "La preparación necesita GPU para renderizar los sprites")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	prepare_hulls()
	for profile in range(2):
		data.perfiles.append({"escala":1.0,"marcha":[],"arranque":[],"cierres":[],"respiracion":[]})
	var viewport := canvas(Vector2i(2048,2560))
	for profile in range(2):
		for i in range(32):
			var cell := profile*32+i
			var figure := RIG.new()
			viewport.add_child(figure)
			figure.build(profile)
			figure.position = position(cell,8)
			figure.pose(i/32.0)
			var pose := descriptor("marcha.png",cell,8)
			pose["fase"] = i
			pose["respiracion_y"] = figure.body.position.y
			var feet := []
			for leg in figure.legs:
				var toe := Vector2(-INF if profile==0 else INF,0)
				for point in leg.hull:
					var pixel: Vector2 = figure.body.position + leg.boot.position + point.rotated(leg.boot.rotation)
					if (pixel.x > toe.x if profile==0 else pixel.x < toe.x): toe=pixel
				feet.append([toe.x+FLOOR.x,toe.y+FLOOR.y])
			pose["punteras"] = feet
			data.perfiles[profile].marcha.append(pose)
	await save(viewport,"marcha.png")
	for profile in range(2):
		viewport = canvas(Vector2i(4096,2560))
		for phase in range(32):
			var closing := []
			for stage in range(4):
				var cell := phase*4+stage
				var figure := RIG.new()
				viewport.add_child(figure)
				figure.build(profile)
				figure.position = position(cell,16)
				figure.pose(phase/32.0,1.0-(stage+1)/4.0)
				var pose:=descriptor("cerrar_"+str(profile)+".png",cell,16)
				pose["respiracion_y"]=figure.body.position.y
				closing.append(pose)
			data.perfiles[profile].cierres.append(closing)
		await save(viewport,"cerrar_"+str(profile)+".png")
	viewport = canvas(Vector2i(2048,960))
	for profile in range(2):
		for i in range(4):
			var cell := profile*9+i
			var figure := RIG.new()
			viewport.add_child(figure)
			figure.build(profile)
			figure.position = position(cell,8)
			figure.pose(0.25+(i+1)*2.0/RIG.STRIDE,(i+1)/4.0)
			var pose:=descriptor("reposo_inicio.png",cell,8)
			pose["respiracion_y"]=figure.body.position.y
			data.perfiles[profile].arranque.append(pose)
		for i in range(5):
			var cell := profile*9+4+i
			var figure := RIG.new()
			viewport.add_child(figure)
			figure.build(profile)
			figure.position=position(cell,8)
			figure.pose(0.0,0.0)
			if i in [2,3]:
				figure.parts.head.position.y-=1
				figure.parts.torso.position.y-=1
			var pose:=descriptor("reposo_inicio.png",cell,8)
			pose["respiracion_y"]=-1 if i in [2,3] else 0
			if i==0: data.perfiles[profile].reposo=pose
			else: data.perfiles[profile].respiracion.append(pose)
	await save(viewport,"reposo_inicio.png")
	# Reutilizar la misma celda evita diferencias de rasterización entre posiciones del atlas.
	for profile in data.perfiles:
		for closing in profile.cierres: closing[3]=profile.reposo
	var file:=FileAccess.open(OUTPUT+"movimiento.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(data,"\t"))
	file.close()
	print("OK: 64 fases propias, 256 enlaces de cierre, ocho de arranque y reposo/respiración desde el mismo modelo articulado.")
	quit()

func canvas(size: Vector2i) -> SubViewport:
	var viewport:=SubViewport.new()
	viewport.size=size
	viewport.transparent_bg=true
	viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	return viewport

func position(cell: int,columns: int) -> Vector2:
	return Vector2((cell%columns)*CELL.x,(cell/columns)*CELL.y)+FLOOR

func descriptor(name: String,cell: int,columns: int) -> Dictionary:
	var x: int=(cell%columns)*CELL.x
	var y: int=(cell/columns)*CELL.y
	return {"archivo":OUTPUT+name,"celda":[x,y,CELL.x,CELL.y],"cadera_x":x+FLOOR.x,"suelo_y":y+FLOOR.y}

func save(viewport: SubViewport,name: String) -> void:
	for n in range(3): await process_frame
	await RenderingServer.frame_post_draw
	var picture:=viewport.get_texture().get_image()
	assert(picture.save_png(OUTPUT+name)==OK)
	viewport.queue_free()
	await process_frame

func prepare_hulls() -> void:
	var cache:=[]
	for profile in range(2):
		var figure:=RIG.new()
		figure.hull_cache=[]
		root.add_child(figure)
		figure.build(profile)
		var hulls:=[]
		for leg in figure.legs:
			var hull:=[]
			for point in leg.hull: hull.append([point.x,point.y])
			hulls.append(hull)
		cache.append(hulls)
		figure.queue_free()
	var file:=FileAccess.open("res://assets/personajes/sota/articulacion_v2.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(cache,"\t"))
	file.close()
