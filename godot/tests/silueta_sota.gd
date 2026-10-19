extends SceneTree

const OUTPUT = "res://../trabajo/arte/revisiones/apoyo_sota_v14/"

func _initialize() -> void: call_deferred("check")

func check() -> void:
	assert(DisplayServer.get_name() != "headless", "Esta prueba necesita render real")
	var before := "--antes" in OS.get_cmdline_user_args()
	var rig = load("res://sota_articulada.gd")
	if before:
		rig = GDScript.new()
		rig.source_code = FileAccess.get_file_as_string("res://../trabajo/arte/revisiones/movimiento_integral_v10/articulacion_antes.gd.txt")
		assert(rig.reload()==OK)
	var failures := 0
	var samples := 0
	for profile in range(2):
		var vp := SubViewport.new()
		vp.size=Vector2i(2048,2560)
		vp.transparent_bg=true
		vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
		root.add_child(vp)
		var figures := []
		for index in range(64):
			var figure = rig.new()
			vp.add_child(figure)
			figure.build(profile)
			figure.position=Vector2((index%8)*256+128,(index/8)*320+300)
			figure.pose((index%32)/32.0)
			for name in figure.parts: figure.parts[name].hide()
			var leg: Dictionary = figure.legs[index/32]
			leg.thigh.show()
			leg.boot.show()
			figures.append(figure)
		for n in range(3): await process_frame
		await RenderingServer.frame_post_draw
		var picture := vp.get_texture().get_image()
		for index in range(64):
			var figure: Node2D = figures[index]
			var leg: Dictionary = figure.legs[index/32]
			for segment in range(2):
				var start: Vector2 = leg.thigh.position if segment==0 else leg.shin.position
				var end: Vector2 = leg.shin.position if segment==0 else leg.boot.position
				var axis := (end-start).normalized()
				var normal := Vector2(axis.y,-axis.x)
				for fraction in [0.35,0.5,0.65]:
					var center: Vector2 = figure.body.to_global(start.lerp(end,fraction))
					var width := 0
					for offset in range(-25,26):
						var point := Vector2i(center+normal*offset)
						if picture.get_pixelv(point).a>0.95: width+=1
					var minimum := 18 if segment==0 else 14
					if width<minimum: failures+=1
					samples+=1
		vp.queue_free()
		await process_frame
	var sheet := SubViewport.new()
	sheet.size=Vector2i(1280,640)
	sheet.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(sheet)
	var bg := ColorRect.new()
	bg.size=Vector2(1280,640)
	bg.color=Color("253040")
	bg.z_index=-100
	sheet.add_child(bg)
	for profile in range(2):
		for pose in range(5):
			var figure = rig.new()
			sheet.add_child(figure)
			figure.build(profile)
			figure.position=Vector2(pose*256+128,profile*320+300)
			figure.pose((pose-1)/4.0 if pose>0 else 0.0,1.0 if pose>0 else 0.0)
	for n in range(3): await process_frame
	await RenderingServer.frame_post_draw
	assert(sheet.get_texture().get_image().save_png(OUTPUT+("antes.png" if before else "despues.png"))==OK)
	print("Silueta: %d/%d secciones de muslo/pantorrilla pierden volumen (mínimos 18/14 px)." % [failures,samples])
	quit(1 if failures else 0)
