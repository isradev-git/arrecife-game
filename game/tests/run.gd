extends SceneTree

var state: Node
var content: Node
var app: Control
var failures: Array[String] = []
var count := 0
var screenshots := false

func _initialize() -> void:
	call_deferred("run")

func check(value: bool, label: String) -> void:
	count += 1
	if not value:
		failures.append(label)
		push_error("FALLO: " + label)

func frames(n: int = 3) -> void:
	for i in n:
		await process_frame

func capture(id: String) -> void:
	if screenshots:
		await create_timer(0.35).timeout
		RenderingServer.force_draw()
		await frames(2)
		var path := ProjectSettings.globalize_path("res://../docs/evidence/" + id + ".png")
		check(root.get_texture().get_image().save_png(path) == OK, "Captura " + id)

func all_buttons(node: Node) -> Array[Button]:
	var result: Array[Button] = []
	for child in node.get_children():
		if child is Button:
			result.append(child)
		result.append_array(all_buttons(child))
	return result

func press(text: String, in_node: Node = null, touch: bool = false) -> void:
	var scope := in_node if in_node else app
	for button in all_buttons(scope):
		var hotspot_text: String = ""
		if button.has_meta("hotspot"):
			var h: Dictionary = button.get_meta("hotspot")
			hotspot_text = ("> " if h.type == "NAVIGATION" else "· ") + h.label
		var choice_text := ""
		if button.text.is_empty() and button.get_child_count() and button.get_child(0) is Label:
			choice_text = button.get_child(0).text
		if (button.text == text or hotspot_text == text or choice_text == text) and button.is_visible_in_tree():
			var position := button.get_global_rect().get_center()
			for down in [true, false]:
				if touch:
					var event := InputEventScreenTouch.new()
					event.position = position
					event.pressed = down
					root.push_input(event, true)
				else:
					var event := InputEventMouseButton.new()
					event.position = position
					event.button_index = MOUSE_BUTTON_LEFT
					event.pressed = down
					root.push_input(event, true)
				await frames()
			return
	check(false, "Botón visible: " + text)

func tap_opening(touch: bool = false) -> void:
	for down in [true, false]:
		if touch:
			var screen_touch := InputEventScreenTouch.new()
			screen_touch.position = app.size * 0.5
			screen_touch.pressed = down
			root.push_input(screen_touch, true)
		else:
			var mouse := InputEventMouseButton.new()
			mouse.position = app.size * 0.5
			mouse.button_index = MOUSE_BUTTON_LEFT
			mouse.pressed = down
			root.push_input(mouse, true)
		await frames()
	if is_instance_valid(app.opening):
		app.opening.timer.stop()
	await create_timer(0.21).timeout

func run() -> void:
	state = root.get_node("State")
	content = root.get_node("Content")
	check(ProjectSettings.get_setting("display/window/handheld/orientation") == 6, "Orientación por sensor para mostrar el aviso en móvil nativo")
	screenshots = DisplayServer.get_name() != "headless"
	state.save_path = "user://prueba_" + str(OS.get_process_id()) + ".json"
	check(content.world.zones.size() == 4, "Cuatro zonas")
	check(content.world.screens.size() == 12, "Doce puntos de vista registrados")
	for sid in content.world.screens:
		var screen: Dictionary = content.world.screens[sid]
		check(content.world.zones.has(screen.zone), "Zona de " + sid)
		var ids := []
		for h in screen.hotspots:
			check(h.id not in ids, "ID único " + sid + "/" + h.id)
			ids.append(h.id)
			check(h.bounds.size() == 4 and h.bounds[0] >= 0 and h.bounds[1] >= 0 and h.bounds[0]+h.bounds[2] <= 1.001 and h.bounds[1]+h.bounds[3] <= 1.001, "Bounds " + h.id)
			var tables := {"OBJECT":content.story.observations,"DOCUMENT":content.story.documents,"PERSON":content.dialogues,"TERMINAL":content.story.terminals,"NAVIGATION":content.world.screens,"SPECIAL_EVENT":content.world.screens}
			if tables.has(h.type):
				check(tables[h.type].has(h.target), "Destino " + h.id)
	for id in content.dialogues:
		var dialogue: Dictionary = content.dialogues[id]
		check(dialogue.nodes.has(dialogue.start), "Inicio diálogo " + id)
		for node in dialogue.nodes.values():
			if node.has("next"):
				check(dialogue.nodes.has(node.next), "Enlace diálogo")
			for choice in node.get("choices", []):
				check(choice.get("end", false) or dialogue.nodes.has(choice.get("next", "")), "Elección enlazada")
	state.new_game()
	check(state.data.screen == "ap_dormitorio" and state.data.missions.retorno_agua == "LOCKED", "Inicio limpio")
	check(not state.navigate("fiebre_calle"), "Salida bloqueada antes del contrato")
	check(not state.accept("retorno_agua"), "No aceptar contrato sin recibir")
	app = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	await frames(8)
	check(app.opening.stage == 0 and not app.menu_visible, "El logo precede al menú")
	app.opening.timer.stop()
	check(all_buttons(app.opening).is_empty(), "Apertura sin botones superpuestos")
	await capture("00_logo")
	await tap_opening()
	check(app.opening.stage == 1, "Crédito del universo tras el logo")
	await capture("00_autoria")
	await tap_opening()
	check(app.opening.stage == 2 and not app.opening.is_portrait_mobile(), "Aviso para ordenador antes del menú")
	await capture("00_aviso_pc")
	await tap_opening(true)
	check(app.menu_visible, "Menú después de las tres pantallas")
	await capture("01_menu")
	check(all_buttons(app.page).size() == 4, "Menú tipográfico sin avatar")
	root.size = Vector2i(844, 390)
	app.show_menu()
	await frames(8)
	check(all_buttons(app.page)[0].get_theme_font_size("font_size") == 18, "Menú móvil con texto ampliado")
	await capture("menu_844x390")
	root.size = Vector2i(1280, 720)
	app.show_menu()
	await frames(8)
	await press("Opciones")
	check(app.overlay.visible, "Opciones desde menú")
	await press("Cerrar ×")
	await press("Créditos")
	check(app.overlay.visible, "Créditos desde menú")
	await press("Cerrar ×")
	app.start_new_game()
	await frames()
	await capture("02_introduccion")
	await press("Saltar introducción")
	check(is_instance_valid(app.current_view), "Introducción saltable")
	await capture("03_dormitorio")
	await press("· La cama")
	check(app.exploration_footer.visible and app.observation.text == content.story.observations.bed, "La observación aparece al tocar la cama")
	check(app.observation.get_global_rect().end.y < app.exploration_footer.get_global_rect().end.y, "Texto completo de la cama dentro de la banda")
	await capture("03_observacion")
	await press("×")
	check(not app.exploration_footer.visible and app.observation_timer.is_stopped(), "La X cierra la observación y detiene su tiempo")
	await press("· La cama", null, true)
	check(app.exploration_footer.visible and not app.observation_timer.is_stopped(), "La cama reabre la observación con toque")
	app.observation_timer.start(0.04)
	await app.observation_timer.timeout
	check(not app.exploration_footer.visible, "La observación desaparece al vencer el tiempo")
	await press("· La cama")
	check(app.exploration_footer.visible, "La observación puede leerse otra vez")
	await press("×")
	var door: Button = app.current_view.spots.back()
	var miss := door.get_global_rect().get_center() + Vector2(35, 0)
	for down in [true, false]:
		var event := InputEventMouseButton.new()
		event.position = miss
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = down
		root.push_input(event, true)
		await frames()
	check(state.data.screen == "ap_dormitorio", "Toque junto a la puerta no activa un área invisible grande")
	await press("Pistas")
	check(app.overlay.visible, "Pistas abre acciones accesibles")
	await press("Ocultar puntos de luz")
	check(not app.current_view.spots[0].get_child(0).visible, "Pistas oculta marcas sin desactivar hotspots")
	await press("Mostrar puntos de luz")
	check(app.current_view.spots[0].get_child(0).visible, "Pistas recupera marcas discretas")
	await press("Deck externo", app.overlay)
	check(app.overlay.visible and app.modal_body.get_child_count() > 0, "Acción nombrada de Pistas abre el deck")
	await press("Cerrar ×")
	await press("· Deck externo")
	check(app.overlay.visible, "Hotspot abre deck con ratón")
	await press("* Un parte que no cuadra · La Jefa")
	check(state.data.missions.retorno_agua == "AVAILABLE", "Mensaje recibe contrato")
	await press("Revisar contrato")
	await capture("04_contrato")
	await press("Aceptar contrato")
	check(state.data.missions.retorno_agua == "ACTIVE", "Contrato activo mediante UI")
	await press("Cerrar ×")
	await press("> Salón / cocina")
	check(state.data.screen == "ap_cocina", "Navegación por hotspot")
	await capture("05_cocina")
	await press("· Recibo del agua")
	check("recibo" in state.data.documents, "Documento leído persistente")
	await press("Página siguiente >")
	await capture("06_documento")
	await press("Cerrar documento")
	await press("· Terminal doméstico")
	await capture("07_terminal")
	await press("Consultar lectura de la conducción")
	check(state.data.flags.get("lectura_copiada", false), "Registro actualiza objetivo")
	await press("Cerrar documento")
	await press("> Baño")
	check(state.data.screen == "ap_bano", "Tercer punto de vista")
	await capture("08_bano")
	await press("· El espejo")
	await capture("09_monologo")
	await press("Volver a la escena")
	# Godot recibe el mismo ScreenTouch que entrega un navegador táctil.
	await press("> Salón / cocina", null, true)
	check(state.data.screen == "ap_cocina", "Navegación mediante toque")
	await press("> Salir a La Fiebre")
	check(state.data.screen == "fiebre_calle", "Ruta entre zonas autorizada")
	await capture("10_fiebre")
	await press("· Hablar con la Jefa")
	await capture("11_dialogo")
	var dialogue = app.overlay.get_child(0)
	check(dialogue.content.other == "jefa", "Interlocutora original")
	var choice: Dictionary = content.dialogues.jefa.nodes.saludo.choices[0]
	for button in all_buttons(dialogue):
		if button.text == choice.text:
			check(button.get_theme_color("font_color") == Color("e9c46a"), "Respuesta de misión en amarillo")
		if button.text == "¿Lo va a cubrir la Nómina?":
			check(button.get_theme_color("font_color") == Color("aeb9b7"), "Pregunta opcional en gris")
	await press(choice.text)
	await frames()
	await press("Continuar >")
	await press("Continuar >")
	check(state.data.flags.get("parte_contrastado", false), "Diálogo actualiza contrato")
	check(state.data.choices.has("jefa:saludo"), "Elección persistente")
	await press("Volver a la escena")
	check(not state.navigate("nudo_acceso"), "Zona futura no simula estar terminada")
	check(state.data.missions.retorno_agua == "ACTIVE", "Hito no completa falsamente misión")
	var snapshot: Dictionary = state.data.duplicate(true)
	state.data = {}
	var loaded: bool = state.load_game()
	for key in snapshot:
		check(state.data.get(key) == snapshot[key], "Campo restaurado: " + key)
	check(loaded and state.data.size() == snapshot.size(), "Guardado y carga completos")
	app.show_menu()
	await frames()
	await press("Continuar")
	check(state.data.screen == snapshot.screen and not app.menu_visible, "Continuar desde menú restaura la vista")
	# Datos truncados, versiones futuras y estructuras mal tipadas.
	for invalid in [null, [], {"version":999}, {"version":1}, {"version":1,"screen":[]}]:
		check(not state.valid(invalid), "Guardado inválido rechazado")
	var malformed: Dictionary = snapshot.duplicate(true)
	malformed.documents = [42]
	check(not state.valid(malformed), "IDs de documento inválidos")
	var file := FileAccess.open(state.save_path, FileAccess.WRITE)
	file.store_string("{ truncado")
	file.close()
	check(state.has_save() and state.load_game(), "Recuperación de copia válida")
	check(not state.last_error.is_empty(), "Recuperación informada")
	state.data = snapshot
	check(state.save_game(), "Guardado tras recuperación")
	for resolution in [Vector2i(1280,720),Vector2i(844,390),Vector2i(1024,768),Vector2i(390,844)]:
		root.size = resolution
		app.show_exploration()
		await frames(8)
		check(app.current_view.size.is_equal_approx(app.page.size), "Paisaje ocupa la pantalla " + str(resolution))
		if resolution == Vector2i(844,390):
			check(app.observation.get_theme_font_size("font_size") >= 18, "Lectura ampliada en horizontal móvil")
			await press("· Entrada de Velvet", null, true)
			check(app.exploration_footer.visible, "Observación visible en móvil horizontal")
			check(app.observation.get_global_rect().end.y < app.exploration_footer.get_global_rect().end.y, "Texto completo de Velvet dentro de la banda móvil")
			await capture("observacion_844x390")
			await press("×", null, true)
			check(not app.exploration_footer.visible, "Cerrar observación mediante toque móvil")
		for button in app.current_view.spots:
			check(button.visible and app.current_view.art_rect().encloses(Rect2(button.position, button.size)), "Área táctil sobre la ilustración " + str(resolution))
			check(button.size.x <= 48.1 and button.size.y <= 48.1, "Área táctil acotada " + str(resolution) + " " + str(button.size))
			check(button.text.is_empty() and button.get_child(0).size.is_equal_approx(Vector2(10,10)), "Indicador circular discreto " + str(resolution))
			check(button.get_child(0).position.is_equal_approx((button.size - Vector2(10,10)) * 0.5), "Indicador centrado en el área pulsable " + str(resolution))
		await capture("viewport_%dx%d" % [resolution.x,resolution.y])
		if resolution == Vector2i(390,844):
			check(app.current_view.image.size.y <= app.current_view.size.x * 0.6, "Ilustración vertical contenida")
			check(app.observation.get_global_rect().end.y <= app.current_view.get_global_rect().end.y, "Observación dentro de la pantalla")
			check(app.exploration_footer.size.y >= 70, "Observación legible en ventana vertical")
			root.size = Vector2i(844,390)
			await frames(8)
			check(app.current_view.size.is_equal_approx(app.page.size), "Rotación a horizontal sin reconstruir la escena")
			root.size = resolution
			await frames(8)
			check(app.current_view.image.size.y <= app.current_view.size.x * 0.6, "Regreso a vertical sin recortar el paisaje")
			await press("· Hablar con la Jefa", null, true)
			check(app.overlay.visible, "Personaje activable tocando la escena en vertical")
			app.close_modal()
		app.show_dialogue("jefa")
		await frames()
		await capture("dialogo_%dx%d" % [resolution.x,resolution.y])
		app.close_modal()
	var mobile_opening = load("res://scripts/ui/startup.gd").new()
	mobile_opening.mobile = true
	root.add_child(mobile_opening)
	mobile_opening.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.size = Vector2i(390, 844)
	await frames(8)
	mobile_opening.advance()
	mobile_opening.advance()
	check(mobile_opening.stage == 2 and mobile_opening.is_portrait_mobile(), "Apertura móvil espera en vertical")
	await capture("00_girar_movil")
	mobile_opening.advance()
	check(mobile_opening.stage == 2, "No se entra al juego con móvil vertical")
	mobile_opening.queue_free()
	app.orientation_gate.mobile = true
	app.orientation_gate.refresh()
	check(app.orientation_gate.visible, "Partida tapada al girar el móvil a vertical")
	root.size = Vector2i(844, 390)
	await frames(8)
	check(not app.orientation_gate.visible, "Partida recuperada al volver a horizontal")
	app.orientation_gate.mobile = false
	# Toda la máquina de misión puede concluir con datos de futuros hitos.
	for step in content.missions.retorno_agua.steps:
		state.apply({"flag":step.flag})
	check(state.data.missions.retorno_agua == "READY_TO_COMPLETE", "Misión lista para entregar")
	state.apply({"flag":"resolucion_entregada"})
	check(state.data.missions.retorno_agua == "COMPLETED", "Misión completada explícitamente")
	state.new_game()
	check(state.data.documents.is_empty() and state.data.discoveries.is_empty() and state.data.choices.is_empty(), "Nueva partida limpia progreso")
	for filename in DirAccess.get_files_at("user://"):
		if filename.begins_with("prueba_" + str(OS.get_process_id())):
			DirAccess.remove_absolute("user://" + filename)
	print("RESULTADO: %d comprobaciones, %d fallos" % [count, failures.size()])
	quit(0 if failures.is_empty() else 1)
