extends SceneTree
const RIG = preload("res://candidatas/sota_postura_v19.gd")
const OUTPUT = "res://assets/personajes/sota/captura_v19_candidata/"
const CELL = Vector2i(192,288)
const ORIGIN = Vector2(96,272)
const PHASES = 64
func _initialize() -> void: call_deferred("run")
func run() -> void:
	assert(DisplayServer.get_name()!="headless")
	var vp := SubViewport.new()
	vp.size=Vector2i(CELL.x*8,CELL.y*16)
	vp.transparent_bg=true
	vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var data := {"fases":PHASES,"distancia_ciclo":RIG.CYCLE_DISTANCE,"perfiles":[],"fuente":"CMU 07_04; vestido v7 heredado, provisional"}
	for profile in range(2):
		var poses := []
		for phase in range(PHASES):
			var index := profile*PHASES+phase
			var cell := Vector2i(index%8,index/8)*CELL
			var rig := RIG.new()
			vp.add_child(rig)
			rig.build(profile)
			rig.position=Vector2(cell)+ORIGIN
			rig.pose(phase/float(PHASES))
			var joints := []
			for leg in rig.joints:
				var pts := []
				for point in leg: pts.append([point.x,point.y])
				joints.append(pts)
			poses.append({"archivo":OUTPUT+"marcha.png","celda":[cell.x,cell.y,CELL.x,CELL.y],"cadera_x":cell.x+ORIGIN.x,"suelo_y":cell.y+ORIGIN.y,"articulaciones":joints,"pelvis":[rig.body.position.x,rig.body.position.y],"elevacion_suelas":[rig.contacts[0].lift,rig.contacts[1].lift]})
		data.perfiles.append({"escala":1.0,"marcha":poses})
	for i in range(3): await process_frame
	await RenderingServer.frame_post_draw
	assert(vp.get_texture().get_image().save_png(OUTPUT+"marcha.png")==OK)
	var file := FileAccess.open(OUTPUT+"movimiento.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(data,"\t"))
	print("OK: 128 poses de captura humana con perfiles propios, atlas aislado.")
	quit()
