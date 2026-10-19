extends SceneTree

func _initialize() -> void:
	create_timer(60).timeout.connect(func(): push_error("La prueba no terminó en 60 s"); quit(1))
	call_deferred("comprobar")

func comprobar() -> void:
	var escena=load("res://laboratorio.tscn").instantiate()
	root.add_child(escena)
	escena.set_physics_process(false)
	var cuerpo=escena.cuerpo
	var esqueleto: Skeleton3D=cuerpo.esqueleto
	assert(esqueleto.get_bone_count()==65)
	assert(cuerpo.origen.get_bone_count()==65)
	assert(cuerpo.reproductor.get_animation_list()==PackedStringArray(["Idle","Walk"]))
	var iniciales := []
	for i in range(65): iniciales.append(esqueleto.get_bone_rest(i).origin.length())
	var distancias := []
	var desviacion := 0.0
	for fps in [30,60,120]:
		var recorrido := Vector3.ZERO
		cuerpo.mezcla=1.0
		cuerpo.arbol.set("parameters/Mezcla/blend_amount",1.0)
		cuerpo.arbol.advance(0.0)
		for i in range(fps*4):
			recorrido+=cuerpo.avanzar(1.0/fps,true)
			await process_frame
			for j in range(65):
				assert(esqueleto.get_bone_pose(j).is_finite())
				assert(esqueleto.get_bone_pose_scale(j).is_equal_approx(Vector3.ONE))
				if j>1: desviacion=maxf(desviacion,absf(esqueleto.get_bone_pose_position(j).length()-iniciales[j]))
		assert(recorrido.z>3.8 and recorrido.z<4.0,"Root motion incoherente")
		distancias.append(recorrido.z)
		print("Root motion a ",fps," FPS: ",recorrido," m en 4 s")
	assert(absf(distancias.max()-distancias.min())<0.005,"Diferencia de avance según FPS")
	assert(desviacion<0.0001,"Longitud de hueso alterada al adaptar la animación")
	print("65 huesos; adaptación nativa sin escalado; error máximo de longitud local: ",desviacion," m")
	for i in range(30): cuerpo.avanzar(1.0/60,false); await process_frame
	assert(cuerpo.mezcla==0)
	assert(cuerpo.avanzar(1.0/60,false).length()<0.00001)
	print("Frenada llega a reposo; root motion nulo en reposo")
	escena.automatico=true
	for i in range(60*8): escena.simular(1.0/60); await process_frame
	assert(escena.cuerpo.position.is_finite())
	assert(absf(escena.cuerpo.position.x)<=2.5)
	assert(absf(escena.cuerpo.position.y)<0.001 and absf(escena.cuerpo.position.z)<0.001,"Deriva fuera del recorrido lateral")
	escena._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	assert(escena.pausa and not escena.automatico and is_inf(escena.destino))
	print("Recorrido lateral y pérdida de foco comprobados")
	if DisplayServer.get_name()!="headless":
		escena.pausa=true
		escena.cuerpo.position=Vector3(-0.7,0,0)
		await process_frame
		await RenderingServer.frame_post_draw
		var carpeta="demo_velvet_3d_v1" if cuerpo.estudio_sota else "locomocion_ilustrada_v1"
		var salida=ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/"+carpeta+"/base_3d.png")
		root.get_texture().get_image().save_png(salida)
		print("Captura nativa guardada: ",salida)
	escena.free()
	quit()
