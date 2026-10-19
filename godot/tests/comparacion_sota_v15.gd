extends SceneTree
const OUT="res://../trabajo/arte/revisiones/cinematica_sota_v15/"
func _initialize() -> void: call_deferred("check")
func check() -> void:
	root.size=Vector2i(1672,941)
	var scene=load("res://candidatas/comparacion_sota_v15.tscn").instantiate()
	root.add_child(scene)
	scene.paused=true
	for phase in [0,8,16,24,32,40,48,56]:
		scene.travel=phase*2.0
		scene.refresh()
		for n in range(3): await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(OUT+"comparacion_%02d.png" % phase)
	scene.debug=true
	scene.refresh()
	for n in range(3): await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUT+"articulaciones.png")
	# Los controles de inspección alteran solo la comparación.
	var previous: float=scene.travel
	scene.step_frame(1)
	assert(scene.paused and is_equal_approx(scene.travel,fposmod(previous+2,128)))
	scene.step_frame(-1)
	assert(is_equal_approx(scene.travel,previous))
	scene.transitions=true
	scene.restart()
	scene.paused=false
	for tick in range(960): scene._process(1.0/120.0)
	for i in range(4):
		assert(scene.sprites[i].scale==Vector2.ONE)
		assert(scene.sprites[i].texture_filter==CanvasItem.TEXTURE_FILTER_NEAREST)
		if i%2==1: assert(not scene.sprites[i].flip_h)
	scene.free()
	print("OK: comparación nativa, cuatro vistas, ocho capturas, overlay, pausa/paso y demo de transiciones.")
	quit()
