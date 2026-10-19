extends SceneTree
const WALK=preload("res://candidatas/movimiento_sota_v15.gd")
func _initialize() -> void: call_deferred("check")
func check() -> void:
	var walk:=WALK.new()
	var source:=Image.load_from_file(ProjectSettings.globalize_path(walk.data.fuente)).get_data()
	var palette: Dictionary={}
	for i in range(0,source.size(),4):
		if source[i+3]>=242: palette[int(source[i])|(int(source[i+1])<<8)|(int(source[i+2])<<16)]=true
	var images: Dictionary={}
	var count:=0
	var validated: Dictionary={}
	for view in walk.data.perfiles:
		var poses: Array=view.marcha+view.arranque+view.respiracion+[view.reposo]
		for closing in view.cierres: poses+=closing
		for pose in poses:
			if not images.has(pose.archivo):
				var img:=Image.load_from_file(ProjectSettings.globalize_path(pose.archivo))
				images[pose.archivo]=img
			if not validated.has(pose.archivo):
				validated[pose.archivo]=true
				var bytes: PackedByteArray=images[pose.archivo].get_data()
				for i in range(0,bytes.size(),4):
					assert(bytes[i+3] in [0,255])
					if bytes[i+3]==255: assert(palette.has(int(bytes[i])|(int(bytes[i+1])<<8)|(int(bytes[i+2])<<16)))
			assert(pose.celda[2]==256 and pose.celda[3]==320)
			var used: Rect2i=images[pose.archivo].get_region(Rect2i(pose.celda[0],pose.celda[1],256,320)).get_used_rect()
			assert(used.position.x>4 and used.end.x<252 and used.position.y>4 and used.end.y<=301)
			var rest: Dictionary=view.reposo
			if not images.has(rest.archivo): images[rest.archivo]=Image.load_from_file(ProjectSettings.globalize_path(rest.archivo))
			for y in range(40,88):
				for x in range(80,190):
					var a: Color=images[pose.archivo].get_pixel(pose.celda[0]+x+pose.cabeza[0],pose.celda[1]+y+pose.cabeza[1])
					var b: Color=images[rest.archivo].get_pixel(rest.celda[0]+x+rest.cabeza[0],rest.celda[1]+y+rest.cabeza[1])
					assert(a.is_equal_approx(b),"Cambio de dibujo en cabeza")
			for leg in pose.articulaciones:
				var h:=Vector2(leg[0][0],leg[0][1])
				var k:=Vector2(leg[1][0],leg[1][1])
				var a:=Vector2(leg[2][0],leg[2][1])
				assert(absf(h.distance_to(k)-56)<0.001 and absf(k.distance_to(a)-56)<0.001)
			count+=1
	assert(walk.data.perfiles[0].marcha[0].celda!=walk.data.perfiles[1].marcha[0].celda)
	var sprite:=Sprite2D.new()
	for profile in range(2):
		walk.reset(profile)
		walk.update(sprite,0,0,profile)
		assert(not sprite.flip_h and sprite.scale==Vector2.ONE and sprite.position==Vector2.ZERO and sprite.texture_filter==CanvasItem.TEXTURE_FILTER_NEAREST)
	sprite.free()
	print("OK: %d poses, paleta exacta v7, alfa binaria, cabeza conservada, 256×320, anclaje fijo, segmentos 56/56 y perfiles propios." % count)
	quit()
