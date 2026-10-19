extends SceneTree

const RIG = preload("res://candidatas/sota_ik_v15.gd")
const OUTPUT = "res://assets/personajes/sota/articulada_v11_candidata/"
const PHASES = 64
const CELL = Vector2i(256,320)
const FLOOR = Vector2(128,300)
var data := {"distancia_ciclo":128.0,"fases":PHASES,"perfiles":[],"fuente":"res://assets/personajes/sota/perfiles_pixel_v7.png","nota":"Fotogramas renderizados en Godot desde una textura v7 compartida; perfiles propios, recortes limpios y tela oculta reconstruida con UV de v7, paleta sin retoques RGB. Escala de juego fija, no normalización por pose."}

func _initialize() -> void:
	call_deferred("check")

func check() -> void:
	assert(DisplayServer.get_name() != "headless", "La preparación necesita GPU para renderizar los sprites")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	# Reutilizar las suelas originales sin reescribir recursos históricos.
	for profile in range(2):
		data.perfiles.append({"escala":1.0,"marcha":[],"arranque":[],"cierres":[],"respiracion":[]})
	var viewport := canvas(Vector2i(2048,5120))
	for profile in range(2):
		for i in range(PHASES):
			var cell := profile*PHASES+i
			var figure := RIG.new()
			viewport.add_child(figure)
			figure.build(profile)
			figure.position = position(cell,8)
			figure.pose(i/float(PHASES))
			var pose := descriptor("marcha.png",cell,8)
			pose["fase"] = i
			pose.merge(geometry(figure))
			pose["respiracion_y"] = roundf(figure.body.position.y)
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
		for page in range(2):
			viewport = canvas(Vector2i(4096,5120))
			var filename := "cerrar_%d_%d.png" % [profile,page]
			for phase in range(page*32,(page+1)*32):
				var closing := []
				for stage in range(8):
					var cell := (phase%32)*8+stage
					var figure := RIG.new()
					viewport.add_child(figure)
					figure.build(profile)
					figure.position = position(cell,16)
					figure.pose(phase/float(PHASES),1.0-(stage+1)/8.0)
					var pose:=descriptor(filename,cell,16)
					pose.merge(geometry(figure))
					pose["respiracion_y"]=roundf(figure.body.position.y)
					closing.append(pose)
				data.perfiles[profile].cierres.append(closing)
			await save(viewport,filename)
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
			pose.merge(geometry(figure))
			pose["respiracion_y"]=roundf(figure.body.position.y)
			data.perfiles[profile].arranque.append(pose)
		for i in range(5):
			var cell := profile*9+4+i
			var figure := RIG.new()
			viewport.add_child(figure)
			figure.build(profile)
			figure.position=position(cell,8)
			figure.pose(0.25,0.0)
			if i in [2,3]:
				figure.parts.head.position.y-=1
				figure.parts.torso.position.y-=1
			var pose:=descriptor("reposo_inicio.png",cell,8)
			pose["respiracion_y"]=-1 if i in [2,3] else 0
			pose.merge(geometry(figure))
			if i==0: data.perfiles[profile].reposo=pose
			else: data.perfiles[profile].respiracion.append(pose)
	await save(viewport,"reposo_inicio.png")
	# Cada parada conserva sus apoyos; no se sustituye por una postura neutral ajena.
	for profile in data.perfiles: profile.reposo=profile.cierres[PHASES/4][-1]
	var file:=FileAccess.open(OUTPUT+"movimiento.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(data,"\t"))
	file.close()
	print("OK: candidata independiente, 128 fases propias y 1024 enlaces, sin sustituir el juego.")
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

func geometry(figure: Node2D) -> Dictionary:
	var joints := []
	for leg in figure.joints:
		var points := []
		for point in leg: points.append([point.x,point.y])
		joints.append(points)
	return {"cabeza":[roundi(figure.body.position.x+figure.parts.head.position.x),roundi(figure.body.position.y+figure.parts.head.position.y)],"articulaciones":joints,"pelvis":[figure.body.position.x,figure.body.position.y],"apoyo":[figure.contacts[0].phase<0.6,figure.contacts[1].phase<0.6],"amplitud":figure.pose_amount}
