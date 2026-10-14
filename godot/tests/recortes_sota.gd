extends SceneTree

const RIG = preload("res://sota_articulada.gd")
const HAND = Rect2i(958,509,43,66)

func _initialize() -> void: call_deferred("check")

func check() -> void:
	var rig = RIG
	if "--antes" in OS.get_cmdline_user_args():
		rig = GDScript.new()
		rig.source_code=FileAccess.get_file_as_string("res://../trabajo/arte/revisiones/modelo_marcha_v6/articulacion_antes.gd.txt")
		assert(rig.reload()==OK)
	var figure = rig.new()
	root.add_child(figure)
	figure.build(1)
	var image := RIG.SOURCE.get_image()
	var wrong := 0
	for name in ["torso"]:
		var node: Polygon2D = figure.parts[name]
		for y in range(HAND.position.y,HAND.end.y):
			for x in range(HAND.position.x,HAND.end.x):
				if in_surface(Vector2(x,y),node) and image.get_pixel(x,y).a>=0.95: wrong+=1
	var skin := 0
	var leg_image := RIG.SEPARATE_LEGS.get_image()
	for y in range(leg_image.get_height()):
		for x in range(leg_image.get_width()):
			var pixel := leg_image.get_pixel(x,y)
			if pixel.a>0.95 and pixel.r>0.55 and pixel.g>0.28 and pixel.b>0.16 and pixel.r>pixel.g*1.3 and pixel.g>pixel.b*1.15: skin+=1
	for leg in figure.legs:
		assert(leg.thigh.texture==RIG.SEPARATE_LEGS and leg.boot.texture==RIG.SEPARATE_LEGS)
	figure.queue_free()
	var right = rig.new()
	root.add_child(right)
	right.build(0)
	var wrong_order: bool = right.parts.deck.z_index>=right.parts.hand1.z_index
	print("Piel en la fuente de piernas: %d; mano lejana en torso: %d; bolsa por encima del brazo: %s" % [skin,wrong,str(wrong_order)])
	right.queue_free()
	await process_frame
	var overlays := 0
	if DisplayServer.get_name()!="headless": overlays=await bag_overlap(rig)
	quit(1 if skin>0 or wrong>0 or wrong_order or overlays>0 else 0)

func bag_overlap(rig: GDScript) -> int:
	var overlap := 0
	var opportunities := 0
	for phase in range(32):
		var vp := SubViewport.new()
		vp.size=Vector2i(1024,320)
		vp.transparent_bg=true
		vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
		root.add_child(vp)
		for mode in range(4):
			var figure = rig.new()
			vp.add_child(figure)
			figure.build(0)
			figure.pose(phase/32.0)
			figure.position=Vector2(mode*256+128,300)
			if mode==1: figure.parts.deck.hide()
			if mode==2 or mode==3:
				for name in figure.parts:
					if not ((mode==2 and name in ["sleeve1","hand1"]) or (mode==3 and name=="deck")): figure.parts[name].hide()
		for tick in range(3): await process_frame
		await RenderingServer.frame_post_draw
		var image := vp.get_texture().get_image()
		for y in range(120,220):
			for x in range(50,200):
				if image.get_pixel(x+512,y).a>0.95 and image.get_pixel(x+768,y).a>0.95:
					opportunities+=1
					if not image.get_pixel(x,y).is_equal_approx(image.get_pixel(x+256,y)): overlap+=1
		vp.queue_free()
		await process_frame
	assert(opportunities>10,"La comprobación debe incluir cruces entre brazo y bolsa")
	print("GPU: %d cruces opacos brazo/bolsa; píxeles donde bolsa tapa brazo: %d" % [opportunities,overlap])
	return overlap

func in_surface(point: Vector2, node: Polygon2D) -> bool:
	if node.polygons.is_empty(): return Geometry2D.is_point_in_polygon(point,node.uv)
	for indices in node.polygons:
		var triangle := PackedVector2Array()
		for index in indices: triangle.append(node.uv[index])
		if Geometry2D.is_point_in_polygon(point,triangle): return true
	return false
