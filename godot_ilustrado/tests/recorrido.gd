extends SceneTree

var escena: Node3D
var asegurar_foco := true
func _initialize() -> void:
	create_timer(150).timeout.connect(func(): push_error("La prueba del recorrido no terminó"); quit(1))
	call_deferred("comprobar")

func tecla(codigo: Key, pulsada: bool) -> void:
	var evento := InputEventKey.new()
	evento.physical_keycode = codigo
	evento.pressed = pulsada
	Input.parse_input_event(evento)
	Input.flush_buffered_events()

func pasos(cantidad: int) -> void:
	for i in range(cantidad):
		# La automatización nativa no debe depender de qué ventana active macOS.
		if asegurar_foco: escena.pausa = false
		await physics_frame
		await process_frame
		assert(absf(escena.jugadora.position.z) < 0.001, "Se abandonó el carril lateral")
		assert(absf(escena.jugadora.position.y) < 0.02, "Se perdió el apoyo en el suelo")

func comprobar() -> void:
	escena = load("res://demo_velvet.tscn" if "--demo" in OS.get_cmdline_user_args() else "res://recorrido_3d.tscn").instantiate()
	root.add_child(escena)
	escena.jugadora.position.x = 0
	escena.camara.position.x = 0
	await pasos(5)
	assert(escena.jugadora.is_on_floor())
	var pie: Vector2 = escena.camara.unproject_position(escena.jugadora.position)
	var cabeza: Vector2 = escena.camara.unproject_position(escena.jugadora.position + Vector3.UP * 1.8)
	var proporcion := pie.distance_to(cabeza) / root.get_visible_rect().size.y
	print("Área lógica de captura: ", root.get_visible_rect().size, " / ventana ", root.size, "; proporción ", proporcion)
	assert(proporcion > 0.12 and proporcion < 0.20, "El encuadre vuelve a acercar demasiado a Sota")
	print("Altura proyectada de Sota: ", proporcion * 100, "% de pantalla")
	tecla(KEY_D, true)
	await pasos(300)
	assert(escena.jugadora.position.x > 4.5)
	assert(absf(escena.camara.position.x - clampf(escena.jugadora.position.x,escena.limites_camara.x,escena.limites_camara.y)) < 1.0)
	tecla(KEY_D, false)
	await pasos(30)
	assert(escena.jugadora.cuerpo.mezcla == 0)
	var parada: Vector3 = escena.jugadora.position
	await pasos(20)
	assert(escena.jugadora.position.distance_to(parada) < 0.001)
	tecla(KEY_A, true)
	await pasos(2)
	tecla(KEY_A, false)
	tecla(KEY_D, true)
	await pasos(25)
	assert(absf(angle_difference(escena.jugadora.cuerpo.rotation.y, PI / 2)) < 0.001, "Giro interrumpido deja el cuerpo oblicuo")
	tecla(KEY_D, false)
	await pasos(30)
	tecla(KEY_A, true)
	await pasos(120)
	tecla(KEY_A, false)
	assert(escena.jugadora.direccion == -1 and escena.jugadora.position.x < parada.x - 1.0)
	var clic := InputEventMouseButton.new()
	clic.button_index = MOUSE_BUTTON_LEFT
	clic.pressed = true
	clic.position = escena.camara.unproject_position(Vector3(6, 0, 0))
	escena._unhandled_input(clic)
	assert(absf(escena.jugadora.destino - 6) < 0.001)
	await pasos(300)
	assert(is_inf(escena.jugadora.destino) and absf(escena.jugadora.position.x - 6) < 0.15)
	tecla(KEY_D, true)
	await pasos(2200)
	tecla(KEY_D, false)
	await pasos(30)
	assert(escena.jugadora.position.x > 37.3 and escena.jugadora.position.x < 37.8)
	assert(escena.jugadora.cuerpo.mezcla == 0, "Marcha contra la barrera")
	assert(escena.camara.position.x <= 34.3)
	escena.jugadora.position.x = -2
	tecla(KEY_A, true)
	await pasos(300)
	tecla(KEY_A, false)
	assert(escena.jugadora.position.x > -3.8 and escena.jugadora.position.x < -3.3)
	assert(escena.jugadora.cuerpo.mezcla == 0)
	# Obstáculo dentro del tramo: debe detectarse físicamente, sin depender de sus extremos.
	escena.jugadora.position.x = 14
	escena.jugadora.direccion = 1
	escena.jugadora.objetivo_direccion = 1
	escena.jugadora.cuerpo.rotation.y = PI / 2
	var pasarela := escena.get_child(0)
	pasarela.caja(Vector3(15, 1, 0), Vector3(0.3, 2, 1), "485354", true)
	await pasos(2)
	tecla(KEY_D, true)
	await pasos(100)
	tecla(KEY_D, false)
	assert(escena.jugadora.position.x < 14.7 and escena.jugadora.cuerpo.mezcla == 0)
	asegurar_foco = false
	escena._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	var antes: Vector3 = escena.jugadora.position
	await pasos(20)
	assert(escena.pausa and is_inf(escena.jugadora.destino))
	assert(antes.distance_to(escena.jugadora.position) < 0.001)
	print("Recorrido 3D: suelo, carril lateral, teclado, cámara, parada, inversión, clic, 42 m, barrera y obstáculo interior, foco: correctos")
	escena.free()
	quit()
