extends SceneTree

const WALK = preload("res://movimiento_sota.gd")
const OUTPUT = "res://../trabajo/arte/revisiones/modelo_marcha_v7/"

func _initialize() -> void:
	call_deferred("check")

func check() -> void:
	var walk:=WALK.new()
	var atlas:=Image.load_from_file(ProjectSettings.globalize_path(walk.data.perfiles[0].marcha[0].archivo))
	var idle:=Image.load_from_file(ProjectSettings.globalize_path(walk.data.perfiles[0].reposo.archivo))
	for profile in range(2):
		walk.reset(profile)
		var view: Dictionary = walk.data.perfiles[profile]
		assert(view.marcha.size()==32 and view.escala==1.0)
		assert(walk.frame_at(0.0)==8 and walk.frame_at(WALK.CYCLE_DISTANCE)==8)
		for i in range(32):
			assert(walk.frame_at(i*4.0)==(i+8)%32)
			var pose: Dictionary=view.marcha[i]
			var texture: AtlasTexture=walk.textures[walk.key(pose)]
			assert(texture.get_size()==Vector2(256,320) and texture.filter_clip)
			var rect:=atlas.get_region(Rect2i(pose.celda[0],pose.celda[1],256,320)).get_used_rect()
			assert(rect.position.x>4 and rect.end.x<252 and rect.position.y>4 and rect.end.y<=301)
		var poses: Array=view.marcha+view.arranque+view.respiracion+[view.reposo]
		for closing in view.cierres: poses+=closing
		var images: Dictionary={}
		for pose in poses:
			if not images.has(pose.archivo): images[pose.archivo]=Image.load_from_file(ProjectSettings.globalize_path(pose.archivo))
			var image: Image=images[pose.archivo]
			var shift:int=int(pose.respiracion_y)
			for y in range(40,88):
				for x in range(80,190):
					var sample:=image.get_pixel(pose.celda[0]+x,pose.celda[1]+y+shift)
					var reference:=idle.get_pixel(view.reposo.celda[0]+x,view.reposo.celda[1]+y)
					assert(sample.is_equal_approx(reference),"Cambio en cabeza: perfil %d, recurso %s celda %s, pixel %d,%d" % [profile,pose.archivo,str(pose.celda),x,y])
	var source:=Image.load_from_file(ProjectSettings.globalize_path(walk.data.fuente)).get_data()
	var palette: Dictionary={}
	for i in range(0,source.size(),4):
		if source[i+3]>=242: palette[int(source[i])|(int(source[i+1])<<8)|(int(source[i+2])<<16)]=true
	var checked: Dictionary={}
	var opaque:=0
	for texture in walk.textures.values():
		var path:String=texture.atlas.resource_path
		if checked.has(path): continue
		checked[path]=true
		var pixels:=Image.load_from_file(ProjectSettings.globalize_path(path)).get_data()
		for i in range(0,pixels.size(),4):
			assert(pixels[i+3] in [0,255],"Transparencia parcial del personaje: "+path)
			if pixels[i+3]==255:
				opaque+=1
				assert(palette.has(int(pixels[i])|(int(pixels[i+1])<<8)|(int(pixels[i+2])<<16)),"Color nuevo ajeno a v7: "+path)
	print("OK: %d píxeles opacos de marcha, inicio, cierre y respiración usan exactamente colores de v7; alfa binaria." % opaque)
	var scene=load("res://recorrido.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	await process_frame
	await physics_frame
	for profile in range(2):
		scene.cancel_movement()
		scene.body.position=Vector2(780,705)
		scene.show_pose(profile)
		var seen: Dictionary={}
		for tick in range(240):
			scene.advance(1.0/60.0,1.0 if profile==0 else -1.0)
			assert(scene.sota.scale==Vector2.ONE and scene.sota.position==Vector2.ZERO)
			assert(not scene.sota.flip_h and not scene.sota.flip_v)
			if scene.walk.state=="marcha": seen[scene.walk.frame_index]=true
		assert(seen.size()==32)
		for tick in range(60): scene.advance(1.0/60.0,0.0)
		assert(scene.walk.state=="reposo" and scene.motion.velocity==0.0)
		scene.walk.reduced_motion=true
		var position:Vector2=scene.body.position
		for tick in range(300):
			scene.advance(1.0/60.0,0.0)
			assert(scene.body.position==position)
			assert(scene.sota.texture==scene.walk.textures[scene.walk.key(scene.walk.data.perfiles[profile].reposo)])
		scene.walk.reduced_motion=false
	for profile in range(2):
		for phase in range(32):
			scene.cancel_movement()
			scene.show_pose(profile)
			scene.body.position.x=scene.MOTION.MAX_X-100-phase*4 if profile==0 else scene.MOTION.MIN_X+100+phase*4
			for tick in range(200):
				scene.advance(1.0/60.0,1.0 if profile==0 else -1.0)
				var corners:Rect2=scene.sota.get_rect()
				var left:Vector2=scene.sota.to_global(corners.position)
				assert(left.x>=0.0 and left.x+corners.size.x<=1672.0)
	if "--capturas" in OS.get_cmdline_user_args() and DisplayServer.get_name()!="headless":
		await capture(scene)
	scene.queue_free()
	await process_frame
	print("OK: 64 fases, región de cabeza idéntica a v7 en marcha y transiciones, cuadros completos, escala fija, ambos sentidos, cierre, reducción, suelo y extremos.")
	quit()

func capture(scene: Node2D) -> void:
	for profile in range(2):
		scene.cancel_movement()
		scene.body.position=Vector2(520 if profile==0 else 1120,705)
		scene.show_pose(profile)
		for tick in range(130):
			scene.advance(1.0/60.0,1.0 if profile==0 else -1.0)
			if tick in [1,10,30,50,70,90,110]:
				await save_frame("%s_%03d" % ["derecha" if profile==0 else "izquierda",tick])
		for tick in range(30):
			scene.advance(1.0/60.0,0.0)
			if tick in [3,12,24]: await save_frame("%s_parada_%02d" % ["derecha" if profile==0 else "izquierda",tick])

func save_frame(name: String) -> void:
	for tick in range(3): await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(OUTPUT+name+".png")==OK)
