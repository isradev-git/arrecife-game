extends SceneTree

func _initialize() -> void:
	create_timer(120).timeout.connect(func(): push_error("La prueba de equipo no terminó"); quit(1))
	call_deferred("comprobar")

func caja_equipo(modelo: Node) -> AABB:
	var caja: AABB = modelo.find_child("Cyberdeck", true, false).get_aabb()
	for nombre in ["Marco cyberdeck", "Indicador cyberdeck"]:
		caja = caja.merge(modelo.find_child(nombre, true, false).get_aabb())
	return caja.grow(0.003)

func comprobar() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("La prueba de equipo necesita GPU para leer la malla deformada")
		quit(1)
		return
	var anterior = preload("res://assets/sota_3d_v1/sota.glb").instantiate()
	var caja_anterior := caja_equipo(anterior)
	anterior.free()
	var cuerpo = preload("res://cuerpo.gd").new()
	cuerpo.estudio_sota = true
	root.add_child(cuerpo)
	var caja_actual := caja_equipo(cuerpo.esqueleto)
	var piel: MeshInstance3D = cuerpo.esqueleto.get_node("Superhero_Female")
	var reposo: PackedVector3Array = piel.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	var triangulos: PackedInt32Array = piel.mesh.surface_get_arrays(0)[Mesh.ARRAY_INDEX]
	var aristas := []
	for i in range(0, triangulos.size(), 3):
		var a := triangulos[i]
		var b := triangulos[i + 1]
		var c := triangulos[i + 2]
		# En la pose T original, este extremo corresponde a mano y antebrazo derechos.
		if reposo[a].x < -0.53 and reposo[b].x < -0.53 and reposo[c].x < -0.53:
			aristas.append(Vector3i(a, b, c))
	assert(not aristas.is_empty())
	var pelvis: int = cuerpo.esqueleto.find_bone("pelvis")
	var arnes: MeshInstance3D = cuerpo.esqueleto.get_node("Correa diagonal")
	var anclaje: MeshInstance3D = cuerpo.esqueleto.get_node("Anclaje correa deck")
	var muestras := 0
	var cruces_anteriores := 0
	for direccion in [-1, 1]:
		cuerpo.rotation.y = direccion * PI / 2
		for i in range(960):
			cuerpo.avanzar(1.0 / 120, i >= 300 and i < 644)
			await process_frame
			var malla := piel.bake_mesh_from_current_skeleton_pose()
			assert(malla != null)
			var vertices: PackedVector3Array = malla.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
			var pelvis_actual: Transform3D = cuerpo.esqueleto.get_bone_global_pose(pelvis) * cuerpo.esqueleto.get_bone_global_rest(pelvis).affine_inverse()
			var inversa := pelvis_actual.affine_inverse()
			var cruce_anterior := false
			for t in aristas:
				var a := inversa * vertices[t.x]
				var b := inversa * vertices[t.y]
				var c := inversa * vertices[t.z]
				for segmento in [[a, b], [b, c], [c, a]]:
					assert(caja_actual.intersects_segment(segmento[0], segmento[1]) == null, "La mano/antebrazo atraviesa el equipo")
					if caja_anterior.intersects_segment(segmento[0], segmento[1]) != null: cruce_anterior = true
			var soporte := anclaje.bake_mesh_from_current_skeleton_pose().get_aabb().grow(0.008)
			var correa: PackedVector3Array = arnes.bake_mesh_from_current_skeleton_pose().surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
			var unido := false
			for v in correa:
				if soporte.has_point(v):
					unido = true
					break
			assert(unido, "La correa se separa del anclaje del cyberdeck")
			if cruce_anterior: cruces_anteriores += 1
			muestras += 1
	assert(cruces_anteriores > 0, "No se reprodujo el cruce anterior")
	print("Equipo: ", muestras, " poses a 120 Hz en ambos sentidos; reposo completo, arranque, marcha y parada. Sin cruces de aristas de mano/antebrazo con caja del equipo +3 mm. Modelo anterior: ", cruces_anteriores, " poses con cruce. Arnés unido al anclaje en todas las muestras.")
	cuerpo.free()
	quit()
