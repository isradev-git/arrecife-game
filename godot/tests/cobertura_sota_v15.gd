extends SceneTree

const RIG = preload("res://candidatas/sota_ik_v15.gd")
const PREVIOUS = "res://../trabajo/arte/revisiones/modelo_marcha_v5/articulacion_antes.gd.txt"
const OUTPUT = "res://../trabajo/arte/revisiones/cinematica_sota_v15/"

func _initialize() -> void:
	call_deferred("check")

func poses() -> Array:
	var values := []
	for phase in range(64):
		values.append([phase/64.0,1.0])
		for stage in range(8): values.append([phase/64.0,1.0-(stage+1)/8.0])
	for stage in range(4): values.append([0.25+(stage+1)*2.0/128.0,(stage+1)/4.0])
	return values

func check() -> void:
	quit(0 if await check_coverage() else 1)

func skin_in_clothing(pixel: Color) -> bool:
	return pixel.a>0.95 and pixel.r>0.55 and pixel.g>0.28 and pixel.b>0.16 and pixel.r>pixel.g*1.3 and pixel.g>pixel.b*1.15

func reproduce_ghost_hand(old: GDScript) -> bool:
	var vp := SubViewport.new()
	vp.size=Vector2i(256,320)
	vp.transparent_bg=true
	vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var figure = old.new()
	vp.add_child(figure)
	figure.build(1)
	figure.pose(0.0)
	figure.position=Vector2(128,300)
	figure.parts.head.hide()
	for arm in figure.arms:
		arm.sleeve.hide()
		arm.hand.hide()
	for n in range(3): await process_frame
	await RenderingServer.frame_post_draw
	var image := vp.get_texture().get_image()
	var skin := 0
	for y in range(165,205):
		for x in range(70,180):
			if skin_in_clothing(image.get_pixel(x,y)): skin+=1
	assert(skin>10,"La prueba debe reproducir la mano incrustada en v4")
	print("Regresión reproducida: %d píxeles de piel en la ropa de v4, perfil izquierdo sin brazos." % skin)
	vp.queue_free()
	await process_frame
	return true

func check_coverage() -> bool:
	var checked := 0
	var skin_total := 0
	var samples := poses()
	for profile in range(2):
		for batch in range(ceili(samples.size()/56.0)):
			var vp := SubViewport.new()
			vp.size = Vector2i(2048,2240)
			vp.transparent_bg = true
			vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
			root.add_child(vp)
			var figures := []
			for index in range(batch*56,mini((batch+1)*56,samples.size())):
				var slot := index-batch*56
				var figure := RIG.new()
				vp.add_child(figure)
				figure.build(profile)
				figure.position = Vector2((slot%8)*256+128,(slot/8)*320+300)
				figure.pose(samples[index][0],samples[index][1])
				figure.parts.head.hide()
				for arm in figure.arms:
					arm.sleeve.hide()
					arm.hand.hide()
				figures.append(figure)
			for n in range(3): await process_frame
			await RenderingServer.frame_post_draw
			var image := vp.get_texture().get_image()
			assert(image.save_png(OUTPUT+"cobertura_%d_%d.png" % [profile,batch])==OK)
			for slot in range(figures.size()):
				var cell := Vector2i((slot%8)*256,(slot/8)*320)
				var figure: Node2D = figures[slot]
				for y in range(165,205):
					for x in range(70,180):
						var pixel := image.get_pixel(cell.x+x+roundi(figure.body.position.x),cell.y+y+roundi(figure.body.position.y))
						if skin_in_clothing(pixel):
							skin_total+=1
							printerr("Piel en ropa: perfil %d, pose %d, pixel %d,%d" % [profile,batch*56+slot,x,y])
				var zones := [Rect2(-26,-184,10,26),Rect2(-24,-144,10,13)] if profile==0 else [Rect2(14,-184,10,26),Rect2(10,-144,10,13)]
				for zone in zones:
					for y in range(int(zone.position.y),int(zone.end.y)):
						for x in range(int(zone.position.x),int(zone.end.x)):
							var point: Vector2 = figure.body.position + Vector2(x,y) + Vector2(128,300) + Vector2(cell)
							assert(image.get_pixel(int(point.x),int(point.y)).a>0.95,"Hueco en torso/cintura, perfil %d pose %d: %s" % [profile,batch*56+slot,str(point-Vector2(cell))])
				for leg in figure.legs:
					var knee: Vector2 = leg.shin.position
					var upper: Vector2 = (knee-leg.thigh.position).normalized()
					var lower: Vector2 = (leg.boot.position-knee).normalized()
					for along in range(-5,6):
						var axis: Vector2 = upper if along<0 else lower
						var normal := Vector2(axis.y,-axis.x)
						for across in range(-3,4):
							var point: Vector2 = figure.body.to_global(knee+axis*along+normal*across)
							assert(image.get_pixel(int(point.x),int(point.y)).a>0.95,"Interrupción en rodilla: perfil %d pose %d, pierna %s punto %s, longitudinal %d lateral %d" % [profile,batch*56+slot,str(leg.hip),str(point-Vector2(cell)),along,across])
					for step in range(-23,5):
						var axis: Vector2 = (leg.boot.position-knee).normalized()
						var normal := Vector2(axis.y,-axis.x)
						for across in range(-2,3):
							var point: Vector2 = figure.body.to_global(leg.boot.position+axis*step+normal*across)
							assert(image.get_pixel(int(point.x),int(point.y)).a>0.95,"Hueco entre pantalón y bota: perfil %d pose %d, pierna %s punto %s, paso %d lateral %d" % [profile,batch*56+slot,str(leg.hip),str(point-Vector2(cell)),step,across])
				checked+=1
			vp.queue_free()
			await process_frame
	assert(skin_total==0,"Piel incrustada en pantalones sin los brazos")
	assert(checked==1160)
	print("OK: 1160 renders sin brazos, sin piel incrustada en ropa y sin huecos en las zonas reconstruidas de torso/cintura ni unión de rodillas/botas.")
	return true
