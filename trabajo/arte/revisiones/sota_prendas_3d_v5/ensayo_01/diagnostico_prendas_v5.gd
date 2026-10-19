extends SceneTree
func _initialize(): call_deferred("comprobar")
func comprobar():
	var cuerpo=preload("res://cuerpo.gd").new()
	cuerpo.estudio_sota=true
	root.add_child(cuerpo)
	for i in range(80):
		cuerpo.avanzar(1.0/60,false)
		await process_frame
	for pieza in cuerpo.esqueleto.get_children():
		if not pieza is MeshInstance3D: continue
		var caja=pieza.bake_mesh_from_current_skeleton_pose().get_aabb()
		if caja.position.x<-.31 or caja.end.x>.31 or caja.position.z<-.22 or caja.end.z>.22:
			print(pieza.name," ",caja)
	quit()
