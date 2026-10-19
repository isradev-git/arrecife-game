extends SceneTree
var escena: Node3D
func _initialize() -> void:
	create_timer(60).timeout.connect(func(): push_error("La prueba no terminó en 60 s"); quit(1))
	call_deferred("comprobar")
func tecla(codigo: Key, pulsada: bool) -> void:
	var evento := InputEventKey.new()
	evento.physical_keycode=codigo
	evento.pressed=pulsada
	Input.parse_input_event(evento)
	Input.flush_buffered_events()
func pasos(cantidad: int) -> void:
	for i in range(cantidad):
		escena.simular(1.0/60)
		await process_frame
func comprobar() -> void:
	escena=load("res://laboratorio.tscn").instantiate()
	root.add_child(escena)
	escena.set_physics_process(false)
	tecla(KEY_D,true)
	await pasos(60)
	assert(escena.cuerpo.position.x>0.5)
	tecla(KEY_D,false)
	await pasos(30)
	assert(escena.cuerpo.mezcla==0)
	var parada: Vector3=escena.cuerpo.position
	await pasos(20)
	assert(escena.cuerpo.position.distance_to(parada)<0.0001)
	tecla(KEY_A,true)
	await pasos(100)
	assert(escena.direccion<0 and escena.cuerpo.position.x<parada.x-0.5)
	tecla(KEY_A,false)
	tecla(KEY_D,true)
	await pasos(15)
	tecla(KEY_D,false)
	tecla(KEY_A,true)
	var desvio := 0.0
	for i in range(60):
		await pasos(1)
		desvio=maxf(desvio,absf(angle_difference(escena.cuerpo.rotation.y,-PI/2)))
	assert(desvio<1.0,"El giro ignoró la interrupción del teclado")
	tecla(KEY_A,false)
	escena.reiniciar()
	var clic := InputEventMouseButton.new()
	clic.button_index=MOUSE_BUTTON_LEFT
	clic.pressed=true
	clic.position=escena.camara.unproject_position(Vector3(-1.3,0,0))
	escena._unhandled_input(clic)
	assert(absf(escena.destino+1.3)<0.001)
	await pasos(200)
	assert(is_inf(escena.destino) and escena.cuerpo.mezcla==0)
	assert(absf(escena.cuerpo.position.x+1.3)<0.15)
	tecla(KEY_D,true)
	await pasos(500)
	tecla(KEY_D,false)
	assert(escena.cuerpo.position.x<=2.5 and escena.cuerpo.mezcla==0,"Marcha contra el límite")
	escena._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	assert(escena.pausa and not escena.automatico and is_inf(escena.destino))
	print("Control: teclado, parada estable, inversión, interrupción del giro, clic/llegada, frenada en límite y foco correctos")
	escena.free()
	quit()
