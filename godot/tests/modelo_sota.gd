extends SceneTree

const RIG = preload("res://sota_articulada.gd")
const PREVIOUS = "res://../trabajo/arte/revisiones/modelo_marcha_v5/articulacion_antes.gd.txt"
const OUTPUT = "res://../trabajo/arte/revisiones/modelo_marcha_v5/"

func _initialize() -> void:
	call_deferred("check")

func poses() -> Array:
	var values := []
	for phase in range(32):
		values.append([phase/32.0,1.0])
		for stage in range(4): values.append([phase/32.0,1.0-(stage+1)/4.0])
	for stage in range(4): values.append([0.25+(stage+1)*2.0/128.0,(stage+1)/4.0])
	return values

func check() -> void:
	var old := GDScript.new()
	old.source_code = FileAccess.get_file_as_string(PREVIOUS)
	assert(old.reload()==OK)
	for profile in range(2):
		var previous = old.new()
		var current := RIG.new()
		root.add_child(previous)
		root.add_child(current)
		previous.build(profile)
		current.build(profile)
		for value in poses():
			previous.pose(value[0],value[1])
			current.pose(value[0],value[1])
			assert(previous.body.transform.is_equal_approx(current.body.transform))
			assert(previous.hip_center.is_equal_approx(current.hip_center))
			for name in ["torso","head","thigh0","thigh1","shin0","shin1","boot0","boot1","sleeve0","sleeve1","hand0","hand1","deck"]:
				assert(previous.parts[name].transform.is_equal_approx(current.parts[name].transform),"Trayectoria modificada: "+name)
			for leg in range(2): assert(previous.legs[leg].hull==current.legs[leg].hull)
		previous.queue_free()
		current.queue_free()
	await process_frame
	var before: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/articulada_v1/movimiento.json"))
	var after: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/articulada_v2/movimiento.json"))
	assert(before.distancia_ciclo==after.distancia_ciclo)
	for profile in range(2):
		for phase in range(32):
			assert(before.perfiles[profile].marcha[phase].punteras==after.perfiles[profile].marcha[phase].punteras)
	print("OK: 328 poses articuladas conservan exactamente transformaciones y contornos; ciclo y punteras preparados idénticos a v4.")
	if DisplayServer.get_name()=="headless":
		quit()
		return
	if await reproduce_ghost_hand(old) != true:
		quit(1)
		return
	quit(0 if await check_coverage() == true else 1)

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
		for batch in range(3):
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
			for slot in range(figures.size()):
				var cell := Vector2i((slot%8)*256,(slot/8)*320)
				var figure: Node2D = figures[slot]
				for y in range(165,205):
					for x in range(70,180):
						var pixel := image.get_pixel(cell.x+x,cell.y+y)
						if skin_in_clothing(pixel):
							skin_total+=1
							printerr("Piel en ropa: perfil %d, pose %d, pixel %d,%d" % [profile,batch*56+slot,x,y])
				var zones := [Rect2(-26,-184,10,26),Rect2(-24,-144,10,13)] if profile==0 else [Rect2(14,-184,10,26),Rect2(17,-144,10,13)]
				for zone in zones:
					for y in range(int(zone.position.y),int(zone.end.y)):
						for x in range(int(zone.position.x),int(zone.end.x)):
							var point: Vector2 = figure.body.position + Vector2(x,y) + Vector2(128,300) + Vector2(cell)
							assert(image.get_pixel(int(point.x),int(point.y)).a>0.95,"Hueco en torso/cintura, perfil %d pose %d: %s" % [profile,batch*56+slot,str(point-Vector2(cell))])
				for leg in figure.legs:
					var corners: PackedVector2Array = leg.lining.polygon
					var upper := (corners[0]+corners[1])*0.5
					var lower := (corners[2]+corners[3])*0.5
					for step in range(1,10):
						var point: Vector2 = leg.lining.to_global(upper.lerp(lower,step/10.0))
						assert(image.get_pixel(int(point.x),int(point.y)).a>0.95,"Hueco entre pantalón y bota: perfil %d pose %d pixel %s" % [profile,batch*56+slot,str(point-Vector2(cell))])
				checked+=1
			assert(image.save_png(OUTPUT+"cobertura_%d_%d.png" % [profile,batch])==OK)
			vp.queue_free()
			await process_frame
	assert(skin_total==0,"Piel incrustada en pantalones sin los brazos")
	assert(checked==328)
	print("OK: 328 renders sin brazos, sin piel incrustada en ropa y sin huecos en las zonas reconstruidas de torso/cintura ni eje de unión con botas.")
	return true
