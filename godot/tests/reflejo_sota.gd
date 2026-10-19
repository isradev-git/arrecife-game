extends SceneTree

const WALK = preload("res://movimiento_sota.gd")
const OUTPUT = "res://../trabajo/arte/revisiones/apoyo_sota_v14/"

func _initialize() -> void: call_deferred("check")

func check() -> void:
	assert(DisplayServer.get_name()!="headless", "Esta prueba compara el render real de Sprite2D")
	var walk := WALK.new()
	var original: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(WALK.DATA_PATH))
	assert(walk.data.perfiles[0]==original.perfiles[0], "El derecho debe conservarse exacto")
	var view: Dictionary = walk.data.perfiles[0]
	var poses: Array = view.marcha+view.arranque+view.respiracion+[view.reposo]
	for closing in view.cierres: poses+=closing
	var checked := 0
	for batch in range(ceili(poses.size()/32.0)):
		var vp := SubViewport.new()
		vp.size=Vector2i(2048,2560)
		vp.transparent_bg=true
		vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
		root.add_child(vp)
		var count := mini(32,poses.size()-batch*32)
		for index in range(count):
			for profile in range(2):
				var sprite := Sprite2D.new()
				vp.add_child(sprite)
				walk.reset(profile)
				walk.apply(sprite,poses[batch*32+index])
				var slot := index*2+profile
				sprite.position=Vector2((slot%8)*256+128,(slot/8)*320+300)
		for tick in range(3): await process_frame
		await RenderingServer.frame_post_draw
		var picture := vp.get_texture().get_image()
		for index in range(count):
			var slot := index*2
			var right := picture.get_region(Rect2i((slot%8)*256,(slot/8)*320,256,320))
			var left := picture.get_region(Rect2i(((slot+1)%8)*256,((slot+1)/8)*320,256,320))
			left.flip_x()
			assert(right.get_data()==left.get_data(), "Diferencia en reflejo/anclaje de pose %d" % (batch*32+index))
			checked+=1
		if batch==0: assert(picture.save_png(OUTPUT+"ciclo_ambos_sentidos.png")==OK)
		vp.queue_free()
		await process_frame
	print("OK: %d pares renderizados son reflejos exactos píxel a píxel, con raíz común; datos derechos intactos." % checked)
	quit()
