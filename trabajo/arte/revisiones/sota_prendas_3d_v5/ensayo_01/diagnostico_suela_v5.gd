extends SceneTree

func _initialize() -> void:
	create_timer(60).timeout.connect(func(): push_error("La prueba no terminó en 60 s"); quit(1))
	call_deferred("comprobar")

func comprobar() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("Esta prueba necesita renderizador GPU para leer la malla deformada")
		quit(1)
		return
	var cuerpo=load("res://cuerpo.gd").new()
	cuerpo.estudio_sota="--sota" in OS.get_cmdline_user_args()
	root.add_child(cuerpo)
	cuerpo.mezcla=1.0
	var mallas: Array[MeshInstance3D]=[]
	for pieza in cuerpo.esqueleto.get_children():
		if pieza is MeshInstance3D and (not cuerpo.estudio_sota or "Botas" in pieza.name or "Suela" in pieza.name or pieza.name == "Detalles calzado"): mallas.append(pieza)
	assert(mallas.size()>=1)
	if cuerpo.estudio_sota:
		mallas.erase(cuerpo.esqueleto.get_node("Botas completas"))
		mallas.push_front(cuerpo.esqueleto.get_node("Botas completas"))
	var marcadores := []
	var inicios := {}
	var deriva := [0.0,0.0]
	var contactos := [0,0]
	if cuerpo.estudio_sota:
		var reposo: PackedVector3Array=mallas[0].mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
		for lado in [-1,1]:
			var punta := -1
			var talon := -1
			for j in range(reposo.size()):
				if reposo[j].x*lado<=0 or reposo[j].y>0.025: continue
				if punta<0 or reposo[j].z>reposo[punta].z: punta=j
				if talon<0 or reposo[j].z<reposo[talon].z: talon=j
			assert(punta>=0 and talon>=0)
			marcadores.append([punta,talon])
	var minimo := INF
	var maximo := -INF
	for i in range(180 if cuerpo.estudio_sota else 100):
		cuerpo.position+=cuerpo.avanzar(1.0/60,true)
		await process_frame
		if i<20: continue
		var base := INF
		for malla in mallas:
			var deformada := malla.bake_mesh_from_current_skeleton_pose()
			assert(deformada!=null)
			for superficie in range(deformada.get_surface_count()):
				var puntos: PackedVector3Array=deformada.surface_get_arrays(superficie)[Mesh.ARRAY_VERTEX]
				for j in range(puntos.size()):
					var y := (malla.global_transform*puntos[j]).y
					if y < -0.0145:
						print("Penetración ", malla.name, " fase ",i," superficie ",superficie," reposo ",malla.mesh.surface_get_arrays(superficie)[Mesh.ARRAY_VERTEX][j]," y ",y)
					base=minf(base,y)
			var vertices: PackedVector3Array=deformada.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
			if cuerpo.estudio_sota and malla == mallas[0]:
				for lado in range(2):
					var punta: Vector3=malla.global_transform*vertices[marcadores[lado][0]]
					var talon: Vector3=malla.global_transform*vertices[marcadores[lado][1]]
					if absf(punta.y-talon.y)<0.012 and maxf(punta.y,talon.y)<0.04:
						var centro := (punta.z+talon.z)*0.5
						if not inicios.has(lado): inicios[lado]=centro
						deriva[lado]=maxf(deriva[lado],absf(centro-inicios[lado]))
						contactos[lado]+=1
					else: inicios.erase(lado)
		minimo=minf(minimo,base)
		maximo=maxf(maximo,base)
	print("Modelo ","Sota" if cuerpo.estudio_sota else "base"," · mínimo/máximo: ",minimo," / ",maximo)
	if minimo<= -0.01 or maximo>=0.015:
		push_error("Contacto vertical fuera del margen de laboratorio")
		cuerpo.free()
		quit(1)
		return
	print("Malla renderizada: borde inferior ",minimo,"..",maximo," m respecto al suelo")
	if cuerpo.estudio_sota:
		assert(contactos[0]>=3 and contactos[1]>=3)
		assert(deriva.max()<0.02,"Deriva excesiva dentro de las ventanas de apoyo plano muestreadas")
		print("Excursión de marcadores de bota en apoyo plano: ",deriva," m; muestras ",contactos)
		print("Ventanas: diferencia punta/talón <12 mm; ambos marcadores <40 mm de altura; no cubre todo el rodado")
	print("Margen técnico, no ausencia absoluta de penetración/flotación ni validación de transiciones")
	cuerpo.free()
	quit()
