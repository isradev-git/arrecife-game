extends SceneTree

const OUTPUT = "res://../trabajo/arte/revisiones/modelo_marcha_v8/"

func _initialize() -> void: call_deferred("check")

func check() -> void:
	var previous := "--antes" in OS.get_cmdline_user_args()
	var folder := "articulada_v4" if previous else "articulada_v5"
	var data: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/"+folder+"/movimiento.json"))
	var differences := 0
	for view in data.perfiles:
		var idle:=cell(view.reposo)
		for closing in view.cierres:
			if cell(closing[-1]).get_data()!=idle.get_data(): differences+=1
	print("Cambios de dibujo al pasar del cierre al reposo: %d / 64" % differences)
	var script = load("res://sota_articulada.gd")
	if previous:
		script=GDScript.new()
		script.source_code=FileAccess.get_file_as_string(OUTPUT+"articulacion_antes.gd.txt")
		assert(script.reload()==OK)
	var shoulder_errors := 0
	for profile in range(2):
		var figure=script.new()
		root.add_child(figure)
		figure.build(profile)
		for phase in range(32):
			for step in range(5):
				figure.pose(phase/32.0,step/4.0)
				if absf(figure.parts.sleeve0.position.x-figure.parts.sleeve1.position.x)>4.0: shoulder_errors+=1
		figure.queue_free()
	print("Hombro lejano adelantado durante cierre: ",shoulder_errors)
	if DisplayServer.get_name()=="headless":
		quit(1 if differences or shoulder_errors else 0)
		return
	var vp:=SubViewport.new()
	vp.size=Vector2i(2048,1280)
	vp.transparent_bg=true
	vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var figures:=[]
	for phase in range(32):
		var figure=script.new()
		vp.add_child(figure)
		figure.build(1)
		figure.pose(phase/32.0)
		figure.position=Vector2((phase%8)*256+128,(phase/8)*320+300)
		for name in figure.parts:
			if name not in ["thigh1","boot1"]: figure.parts[name].hide()
		figures.append(figure)
	for n in range(3): await process_frame
	await RenderingServer.frame_post_draw
	var image:=vp.get_texture().get_image()
	var minimum:=100
	var narrow:=0
	for figure in figures:
		var leg: Dictionary=figure.legs[1]
		var axis:Vector2=(leg.shin.position-leg.thigh.position).normalized()
		var normal:=Vector2(axis.y,-axis.x)
		var center:Vector2=figure.body.to_global(leg.thigh.position.lerp(leg.shin.position,0.65))
		var width:=0
		for across in range(-20,21):
			var point:=Vector2i(center+normal*across)
			if image.get_pixelv(point).a>0.95: width+=1
		minimum=mini(minimum,width)
		if width<22: narrow+=1
	print("Anchura mínima del muslo izquierdo: %d px; fases por debajo de 22 px: %d" % [minimum,narrow])
	image.save_png(OUTPUT+("volumen_antes.png" if previous else "volumen_despues.png"))
	quit(1 if differences or shoulder_errors or narrow else 0)

func cell(pose: Dictionary) -> Image:
	var image:=Image.load_from_file(ProjectSettings.globalize_path(pose.archivo))
	return image.get_region(Rect2i(pose.celda[0],pose.celda[1],256,320))
