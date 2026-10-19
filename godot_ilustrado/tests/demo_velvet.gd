extends SceneTree

func _initialize() -> void:
	create_timer(60).timeout.connect(func(): push_error("Tiempo agotado en demo"); quit(1))
	call_deferred("comprobar")

func comprobar() -> void:
	var escena = load("res://demo_velvet.tscn").instantiate()
	root.add_child(escena)
	assert(escena.get_child(0).humo.size() == 7)
	assert(escena.get_child(0).ventiladores.size() == 4)
	assert(escena.get_child(0).figurantes.size() == 4)
	assert(escena.get_child(0).paseantes.size() == 3)
	await physics_frame
	for posicion in [Vector3(9,2,8),Vector3(8,2,-8),Vector3(34,2,6)]:
		var consulta := PhysicsRayQueryParameters3D.create(posicion,posicion-Vector3.UP*4)
		var apoyo: Dictionary = escena.get_world_3d().direct_space_state.intersect_ray(consulta)
		assert(not apoyo.is_empty() and apoyo.position.y > -.1,"La calle o el acceso lateral vuelven a quedar suspendidos")
	await process_frame
	for i in range(escena.ENCUENTROS.size()):
		escena.jugadora.position.x = escena.ENCUENTROS[i].x
		escena.pausa = false
		await process_frame
		await process_frame
		assert(escena.cercano == i and escena.interactuar.visible)
		# Fijar el foco al iniciar cada lectura automatizada; se comprueba aparte al final.
		escena.pausa = false
		escena.jugadora.cuerpo.mezcla = 1.0
		escena.abrir_lectura()
		assert(escena.lectura.visible and escena.pausa)
		assert(escena.texto.text == escena.ENCUENTROS[i].lineas[0][1])
		var clic := InputEventMouseButton.new()
		clic.button_index = MOUSE_BUTTON_LEFT
		clic.pressed = true
		clic.position = escena.camara.unproject_position(Vector3(37,0,0))
		escena._unhandled_input(clic)
		assert(is_inf(escena.jugadora.destino), "El clic atraviesa el diálogo")
		escena.cambiar_pausa()
		assert(escena.pausa, "Espacio reanuda mientras se lee")
		for j in range(20): await physics_frame
		assert(escena.jugadora.cuerpo.mezcla == 0)
		assert(escena.retrato_otro.visible == (i == 2), "Retrato ajeno en monólogo")
		for linea in range(escena.ENCUENTROS[i].lineas.size()):
			for j in range(12): await process_frame
			var habla_sota: bool = escena.ENCUENTROS[i].lineas[linea][0] == "SOTA"
			assert(escena.retrato_sota.modulate.r > .9 if habla_sota else escena.retrato_sota.modulate.r < .4)
			if i == 2: assert(escena.retrato_otro.modulate.r < .4 if habla_sota else escena.retrato_otro.modulate.r > .9)
			escena.avanzar_linea()
		assert(not escena.lectura.visible and not escena.pausa)
	escena.pausa = true
	escena.abrir_lectura()
	escena.cerrar_lectura()
	assert(escena.pausa, "Se pierde la pausa previa a la lectura")
	escena._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	assert(escena.pausa and is_inf(escena.jugadora.destino))
	print("Demo: cuatro lecturas, cierre, pausa previa, bloqueo de clic, frenada y foco correctos")
	escena.free()
	var visor = load("res://sota_360.tscn").instantiate()
	root.add_child(visor)
	visor.rotacion_automatica = false
	for i in range(8):
		visor.angulo = i*TAU/8
		visor.actualizar_camara()
		assert(visor.camara.transform.is_finite())
		assert(not visor.camara.is_position_behind(Vector3(0,visor.altura,0)))
	print("Visor: cámara válida en los ocho ángulos")
	await process_frame
	await RenderingServer.frame_post_draw
	visor.free()
	quit()
