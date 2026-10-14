extends SceneTree

const RIG = preload("res://sota_articulada.gd")
const OUTPUT = "res://../trabajo/arte/revisiones/modelo_marcha_v9/"

func _initialize() -> void: call_deferred("check")

func depth(node: CanvasItem) -> int:
	var total := node.z_index
	var parent := node.get_parent()
	while node.z_as_relative and parent is CanvasItem:
		node=parent
		total+=node.z_index
		parent=node.get_parent()
	return total

func check() -> void:
	var rig = RIG
	if "--antes" in OS.get_cmdline_user_args():
		rig=GDScript.new()
		rig.source_code=FileAccess.get_file_as_string("res://../trabajo/arte/revisiones/modelo_marcha_v7/articulacion_antes.gd.txt")
		assert(rig.reload()==OK)
	var failures := 0
	for profile in range(2):
		var figure = rig.new()
		root.add_child(figure)
		figure.build(profile)
		if figure.legs[1].thigh.get_parent()!=figure.body:
			assert(figure.legs[1].thigh.get_parent().get_index()<figure.parts.deck.get_index(),"La ropa no debe tapar la bolsa al compartir profundidad")
		for phase in range(32):
			figure.pose(phase/32.0)
			if absf(figure.parts.sleeve0.position.x-figure.parts.sleeve1.position.x)>4.0: failures+=1
			if absf(figure.legs[0].thigh.position.x-figure.legs[1].thigh.position.x)>4.0: failures+=1
			for leg in figure.legs:
				if depth(leg.boot)<=depth(leg.shin): failures+=1
			if depth(figure.legs[0].boot)>=depth(figure.legs[1].thigh): failures+=1
		figure.queue_free()
	await process_frame
	print("Montaje: %d fallos de hombro/cadera/orden de botas en 64 poses" % failures)
	if failures>0:
		quit(1)
		return
	if DisplayServer.get_name()!="headless": await check_occlusion(rig)
	quit()

func check_occlusion(rig: GDScript) -> void:
	var crossings := 0
	for profile in range(2):
		var viewports := []
		for mode in range(3):
			var vp := SubViewport.new()
			vp.size=Vector2i(2048,1280)
			vp.transparent_bg=true
			vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
			root.add_child(vp)
			viewports.append(vp)
			for phase in range(32):
				var figure = rig.new()
				vp.add_child(figure)
				figure.build(profile)
				figure.pose(phase/32.0)
				figure.position=Vector2((phase%8)*256+128,(phase/8)*320+300)
				for name in figure.parts:
					if not name.begins_with("thigh") and not name.begins_with("boot"): figure.parts[name].hide()
				if mode==1:
					figure.legs[0].thigh.hide()
					figure.legs[0].boot.hide()
				if mode==2:
					figure.legs[1].thigh.hide()
					figure.legs[1].boot.hide()
		for n in range(3): await process_frame
		await RenderingServer.frame_post_draw
		var full: Image = viewports[0].get_texture().get_image()
		var front: Image = viewports[1].get_texture().get_image()
		var back: Image = viewports[2].get_texture().get_image()
		for y in range(full.get_height()):
			for x in range(full.get_width()):
				if front.get_pixel(x,y).a>0.95 and back.get_pixel(x,y).a>0.95:
					crossings+=1
					assert(full.get_pixel(x,y).is_equal_approx(front.get_pixel(x,y)),"La pierna lejana atraviesa la cercana: perfil %d pixel %d,%d" % [profile,x,y])
		for mode in range(3):
			assert(viewports[mode].get_texture().get_image().save_png(OUTPUT+"planos_piernas_%d_%d.png" % [profile,mode])==OK)
			viewports[mode].queue_free()
		await process_frame
	assert(crossings>100)
	print("GPU: %d cruces opacos; la pierna y bota lejanas siempre quedan detrás de la pierna cercana." % crossings)
