extends SceneTree
func _initialize() -> void: call_deferred("comprobar")
func comprobar() -> void:
	var escena=load("res://demo_velvet.tscn").instantiate()
	root.add_child(escena)
	escena.set_physics_process(false)
	escena.set_process(false)
	var barrio=escena.get_child(0)
	barrio.set_process(false)
	for persona in barrio.figurantes + barrio.paseantes.map(func(v): return v.cuerpo):
		assert(persona.esqueleto.get_bone_count()==65)
		for pieza in persona.esqueleto.get_children():
			if pieza is MeshInstance3D:
				assert(pieza.mesh.get_surface_count()==1,"La figuración vuelve a multiplicar materiales")
				var arrays=pieza.mesh.surface_get_arrays(0)
				for vertice in arrays[Mesh.ARRAY_VERTEX]:assert(vertice.is_finite())
				var pesos=arrays[Mesh.ARRAY_WEIGHTS]
				for i in range(0,pesos.size(),4):assert(absf(pesos[i]+pesos[i+1]+pesos[i+2]+pesos[i+3]-1)<.002)
	print("Figuración: 65 huesos, una superficie por modelo, vértices finitos y pesos normalizados")
	assert(is_equal_approx(barrio.BORDE_CALZADA-1.8,2.3))
	for x in [-3.5,37.5]:
		escena.camara.position.x=x
		escena.ajustar_encuadre()
		var tamano=root.get_visible_rect().size
		for px in [0.0,tamano.x]:
			var borde=Plane(Vector3.BACK,0).intersects_ray(escena.camara.project_ray_origin(Vector2(px,tamano.y/2)),escena.camara.project_ray_normal(Vector2(px,tamano.y/2)))
			assert(borde.x>=-4.01 and borde.x<=38.01,"La cámara muestra prolongación fuera del tramo")
	print("Cámara: extremos del plano de juego dentro de -4..38 m; carretera de 2,3 m")
	escena.pausa=false
	var inversiones=0
	for i in range(7200):
		for vecino in barrio.paseantes:
			vecino.cuerpo.set_meta("sentido_anterior",vecino.sentido)
		barrio._process(1.0/60)
		for vecino in barrio.paseantes:
			assert(vecino.cuerpo.position.is_finite())
			assert(vecino.cuerpo.position.x>=vecino.inicio-.02 and vecino.cuerpo.position.x<=vecino.fin+.02,"Un paseante sale de su recorrido")
			if vecino.sentido!=vecino.cuerpo.get_meta("sentido_anterior"):inversiones+=1
	assert(inversiones>=12)
	var posiciones=[]
	for vecino in barrio.paseantes:posiciones.append(vecino.cuerpo.position)
	escena.pausa=true
	barrio._process(1)
	for i in range(posiciones.size()):assert(posiciones[i]==barrio.paseantes[i].cuerpo.position)
	print("Vecindario: tres rutas, ",inversiones," cambios de sentido en 120 s, pausa y posiciones válidas")
	for fps in [30,60,120]:
		var cuerpo=load("res://cuerpo.gd").new()
		cuerpo.estudio_sota=true
		root.add_child(cuerpo)
		cuerpo.mezcla=1
		var distancia=0.0
		for i in range(fps*4):distancia+=cuerpo.avanzar(1.0/fps*escena.jugadora.CADENCIA,true).z
		assert(absf(distancia-3.9*1.12)<.01)
		print("Cadencia Sota ",fps," FPS: ",distancia," m / 4 s (+12 %)")
		await process_frame
		await RenderingServer.frame_post_draw
		cuerpo.free()
	escena.free()
	quit()
