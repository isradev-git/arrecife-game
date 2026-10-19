extends SceneTree

func _initialize() -> void:
	create_timer(60).timeout.connect(func(): push_error("La prueba no terminó en 60 s"); quit(1))
	call_deferred("comprobar")
func comprobar() -> void:
	var cuerpo=preload("res://cuerpo.gd").new()
	cuerpo.estudio_sota=true
	root.add_child(cuerpo)
	# La revisión de aspecto debe conservar la base del movimiento aprobado en v3.
	var anterior := preload("res://assets/sota_3d_v3/sota.glb").instantiate()
	var esqueleto_anterior: Skeleton3D = anterior.find_child("Skeleton3D", true, false)
	assert(cuerpo.esqueleto.get_bone_count() == esqueleto_anterior.get_bone_count())
	for i in range(esqueleto_anterior.get_bone_count()):
		assert(cuerpo.esqueleto.get_bone_name(i) == esqueleto_anterior.get_bone_name(i))
		assert(cuerpo.esqueleto.get_bone_parent(i) == esqueleto_anterior.get_bone_parent(i))
		assert(cuerpo.esqueleto.get_bone_rest(i).is_equal_approx(esqueleto_anterior.get_bone_rest(i)))
	var botas: Mesh = cuerpo.esqueleto.get_node("Botas completas").mesh
	var botas_anteriores: Mesh = esqueleto_anterior.get_node("Botas completas").mesh
	var suela_previa: PackedVector3Array = botas_anteriores.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	var posiciones := {}
	for p in suela_previa: posiciones[p] = true
	var posiciones_actuales := {}
	for p in botas.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		assert(posiciones.has(p), "La revisión alteró la geometría original de apoyo")
		posiciones_actuales[p] = true
	assert(posiciones_actuales.size() == posiciones.size(), "Faltan vértices originales de apoyo")
	anterior.free()
	var piezas := 0
	var vertices := 0
	for pieza in cuerpo.esqueleto.get_children():
		if not pieza is MeshInstance3D: continue
		piezas+=1
		assert(pieza.skin!=null)
		for superficie in range(pieza.mesh.get_surface_count()):
			var datos: Array=pieza.mesh.surface_get_arrays(superficie)
			var puntos: PackedVector3Array=datos[Mesh.ARRAY_VERTEX]
			var pesos: PackedFloat32Array=datos[Mesh.ARRAY_WEIGHTS]
			var huesos: PackedInt32Array=datos[Mesh.ARRAY_BONES]
			assert(not puntos.is_empty() and not pesos.is_empty())
			var influencias: int=pesos.size()/puntos.size()
			assert(influencias==4 or influencias==8)
			assert(huesos.size()==pesos.size())
			for i in range(puntos.size()):
				assert(puntos[i].is_finite())
				var suma := 0.0
				for j in range(influencias):
					var indice := i*influencias+j
					assert(is_finite(pesos[indice]) and pesos[indice]>=0)
					assert(huesos[indice]>=0 and huesos[indice]<pieza.skin.get_bind_count())
					suma+=pesos[indice]
				assert(absf(suma-1.0)<0.001,"Vértice sin pesos normalizados")
			vertices+=puntos.size()
	var chaqueta: MeshInstance3D = cuerpo.esqueleto.get_node("Chaqueta")
	for nombre in ["Chaqueta", "Pantalon", "Correa diagonal", "Prenda interior", "Botas completas"]:
		var prenda: MeshInstance3D = cuerpo.esqueleto.get_node(nombre)
		var material: StandardMaterial3D = prenda.get_active_material(0)
		assert(material.albedo_texture != null and material.normal_enabled and material.normal_texture != null, "Prenda sin texturas de color/relieve")
		assert(material.roughness_texture != null, "Prenda sin mapa de rugosidad")
		assert(not prenda.mesh.surface_get_arrays(0)[Mesh.ARRAY_TEX_UV].is_empty(), "Prenda sin coordenadas UV")
	assert(not chaqueta.get_active_material(0).vertex_color_use_as_albedo, "La chaqueta debe usar su material texturizado")
	var deck=cuerpo.esqueleto.get_node("Cyberdeck")
	assert(deck.get_aabb().end.x<0.0,"Deck fuera del lado físico derecho")
	assert(piezas>=26)
	for nombre in ["Chaqueta", "Prenda interior", "Pantalon", "Correa diagonal", "Pelo corto", "Mechon gris", "Anclaje correa deck"]:
		assert(cuerpo.esqueleto.has_node(nombre), "Falta una parte de la candidata")
	var rodilla=cuerpo.esqueleto.find_bone("calf_r")
	var inicial=cuerpo.esqueleto.get_bone_pose_rotation(rodilla)
	var excursion := 0.0
	for i in range(120):
		cuerpo.avanzar(1.0/60,true)
		await process_frame
		excursion=maxf(excursion,inicial.angle_to(cuerpo.esqueleto.get_bone_pose_rotation(rodilla)))
	assert(excursion>0.2,"El destino no recibe la animación")
	print("Sota: ",piezas," piezas, ",vertices," vértices con pesos normalizados; deck en lado físico derecho; retarget activo")
	cuerpo.free()
	quit()
