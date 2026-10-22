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

func has_button(label: String, node: Node) -> bool:
	for button in all_buttons(node):
		if button.text == label and button.is_visible_in_tree():
			return true
	return false

func portrait_floor_gap(portrait: TextureRect, floor_y: float) -> float:
	var drawn_height := minf(portrait.size.y, portrait.size.x * float(portrait.texture.get_height()) / portrait.texture.get_width())
	return floor_y - portrait.global_position.y - (portrait.size.y + drawn_height) * 0.5

func has_navigation(from_id: String, to_id: String) -> bool:
	if not content.world.screens.has(from_id):
		return false
	for hotspot in content.world.screens[from_id].hotspots:
		if hotspot.type == "NAVIGATION" and hotspot.target == to_id:
			return true
	return false

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
			var ancestor := button.get_parent()
			while ancestor and not ancestor is ScrollContainer:
				ancestor = ancestor.get_parent()
			if ancestor is ScrollContainer:
				ancestor.ensure_control_visible(button)
				await frames(2)
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
	check(content.missions.size() == 3, "Tres contratos para la versión 0.2.0")
	check(content.world.zones.size() == 4, "Cuatro zonas")
	check(content.world.screens.size() == 21, "Veintiún puntos de vista registrados")
	var fiebre_ids := ["fiebre_calle", "fiebre_entrada", "fiebre_encuentro", "fiebre_galeria", "fiebre_suministros", "fiebre_descenso"]
	var nudo_ids := ["nudo_acceso", "nudo_taller", "nudo_terminal", "nudo_mercado", "nudo_archivo", "nudo_paso_inferior"]
	var puntales_ids := ["puntales_acceso", "puntales_taller", "puntales_observatorio", "puntales_soportes", "puntales_presion", "puntales_verificacion"]
	var fiebre_count := 0
	var implemented_count := 0
	var arts := []
	var unique_arts := {}
	for sid in content.world.screens:
		implemented_count += int(content.world.screens[sid].implemented)
		if content.world.screens[sid].has("art"):
			arts.append(content.world.screens[sid].art)
			unique_arts[content.world.screens[sid].art] = true
		if sid in fiebre_ids:
			fiebre_count += 1
	check(fiebre_count == 6 and content.world.zones.fiebre.screens.size() == 6, "Seis vistas de La Fiebre")
	check(implemented_count == 21 and arts.size() == 21 and unique_arts.size() == 21, "Veintiún fondos propios jugables")
	check(content.world.zones.apartamento.screens.size() == 3 and content.world.zones.fiebre.screens.size() == 6 and content.world.zones.nudo.screens.size() == 6 and content.world.zones.puntales.screens.size() == 6, "Distribución 3/6/6/6")
	for pair in [["fiebre_calle", "fiebre_entrada"], ["fiebre_calle", "fiebre_encuentro"], ["fiebre_calle", "fiebre_galeria"], ["fiebre_calle", "fiebre_descenso"], ["fiebre_galeria", "fiebre_suministros"], ["fiebre_galeria", "fiebre_descenso"]]:
		check(has_navigation(pair[0], pair[1]) and has_navigation(pair[1], pair[0]), "Ruta doble " + pair[0] + "/" + pair[1])
	for sid in fiebre_ids:
		if content.world.screens.has(sid):
			var screen_data: Dictionary = content.world.screens[sid]
			check(screen_data.implemented and FileAccess.file_exists("res://assets/backgrounds/candidates/%s.png" % screen_data.get("art", "")), "Fondo propio " + sid)
	check(content.world.zones.nudo.screens.size() == 6, "Seis vistas de El Nudo")
	for pair in [["nudo_acceso", "nudo_taller"], ["nudo_taller", "nudo_terminal"], ["nudo_terminal", "nudo_archivo"], ["nudo_archivo", "nudo_mercado"], ["nudo_mercado", "nudo_acceso"], ["nudo_archivo", "nudo_paso_inferior"]]:
		check(has_navigation(pair[0], pair[1]) and has_navigation(pair[1], pair[0]), "Ruta doble " + pair[0] + "/" + pair[1])
	check(has_navigation("fiebre_descenso", "nudo_acceso") and has_navigation("nudo_acceso", "fiebre_descenso"), "Descenso y subida físicos entre La Fiebre y El Nudo")
	for sid in nudo_ids:
		if content.world.screens.has(sid):
			var screen_data: Dictionary = content.world.screens[sid]
			check(screen_data.implemented and FileAccess.file_exists("res://assets/backgrounds/candidates/%s.png" % screen_data.get("art", "")), "Fondo propio " + sid)
	for pair in [["puntales_acceso", "puntales_taller"], ["puntales_taller", "puntales_observatorio"], ["puntales_observatorio", "puntales_soportes"], ["puntales_soportes", "puntales_presion"], ["puntales_presion", "puntales_verificacion"], ["puntales_verificacion", "puntales_acceso"]]:
		check(has_navigation(pair[0], pair[1]) and has_navigation(pair[1], pair[0]), "Ruta doble " + pair[0] + "/" + pair[1])
	check(has_navigation("nudo_paso_inferior", "puntales_acceso") and has_navigation("puntales_acceso", "nudo_paso_inferior"), "Descenso y subida físicos entre El Nudo y Los Puntales")
	for sid in puntales_ids:
		if content.world.screens.has(sid):
			var screen_data: Dictionary = content.world.screens[sid]
			check(screen_data.implemented and FileAccess.file_exists("res://assets/backgrounds/candidates/%s.png" % screen_data.get("art", "")), "Fondo propio " + sid)
	var links := {}
	var returns := {}
	for sid in content.world.screens:
		links[sid] = []
		returns[sid] = []
	for sid in content.world.screens:
		for hotspot in content.world.screens[sid].hotspots:
			if hotspot.type == "NAVIGATION" and content.world.screens.has(hotspot.target):
				links[sid].append(hotspot.target)
				returns[hotspot.target].append(sid)
	for graph in [links, returns]:
		var reached := {"ap_dormitorio": true}
		var pending := ["ap_dormitorio"]
		while not pending.is_empty():
			for target in graph[pending.pop_front()]:
				if not reached.has(target):
					reached[target] = true
					pending.append(target)
		check(reached.size() == 21, "Todas las vistas alcanzables y con regreso" if graph == returns else "Todas las vistas alcanzables desde casa")
	check(content.world.screens.fiebre_calle.hotspots[0].type == "OBJECT" and content.world.screens.fiebre_calle.hotspots[1].type == "PERSON", "Velvet y Jefa permanecen en el pasaje")
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
	var fixture_path := "res://tests/fixtures/partida_h1_v1.json"
	check(DirAccess.copy_absolute(ProjectSettings.globalize_path(fixture_path), ProjectSettings.globalize_path(state.save_path)) == OK, "Fixture de partida anterior copiado")
	check(state.load_game(), "Partida v1 anterior cargada")
	check(state.data.screen == "fiebre_calle" and state.data.zone == "fiebre", "Ubicación v1 conservada")
	check(state.data.missions == {"retorno_agua": "ACTIVE", "orden_duplicada": "LOCKED", "prueba_presion": "LOCKED"} and state.data.flags.has("orden_visita") and state.data.flags.has("acreditacion_residencia"), "Partida v1 amplía misiones sin perder permisos")
	check(state.data.documents == ["recibo"] and state.data.choices.has("jefa:saludo"), "Documentos y elección v1 conservados")
	var exploration_state: Dictionary = state.data.duplicate(true)
	for target in ["fiebre_descenso", "nudo_acceso", "nudo_taller", "nudo_terminal", "nudo_archivo", "nudo_paso_inferior", "puntales_acceso", "puntales_taller", "puntales_observatorio", "puntales_soportes", "puntales_presion", "puntales_verificacion", "puntales_acceso", "nudo_paso_inferior", "nudo_archivo", "nudo_mercado", "nudo_acceso", "fiebre_descenso", "fiebre_calle"]:
		check(has_navigation(state.data.screen, target), "Partida anterior sigue salida física a " + target)
		check(state.navigate(target), "Partida anterior navega a " + target)
	for field in ["missions", "flags", "documents", "choices"]:
		check(state.data[field] == exploration_state[field], "Explorar conserva " + field)
	state.new_game()
	check(state.data.screen == "ap_dormitorio" and state.data.missions.retorno_agua == "LOCKED", "Inicio limpio")
	for id in ["madre_inicio", "madre_seguimiento", "hermana_grupo", "jefa_contacto", "lia_pasaje", "lia_cierre"]:
		check(content.story.messages.has(id), "Episodio de chat disponible: " + id)
	check(state.has_method("unread_messages"), "Estado calcula mensajes sin leer")
	if state.has_method("unread_messages"):
		check(state.unread_messages().has("encargo") and state.unread_messages().has("madre_inicio") and not state.unread_messages().has("hermana_grupo"), "Llegadas iniciales y futuras separadas")
	check(state.has_method("reply_to_message"), "Estado conserva respuestas de los chats")
	if state.has_method("reply_to_message"):
		check(not state.reply_to_message("madre_inicio", "broma"), "No se responde un mensaje sin abrirlo")
	check(not state.navigate("fiebre_calle"), "Salida bloqueada antes del contrato")
	check(not state.navigate("nudo_acceso"), "Descenso sin orden de visita bloqueado")
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
	check(app.get("ambience_player") is AudioStreamPlayer and app.ambience_player.stream is AudioStreamWAV and app.ambience_player.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD, "Ambiente sonoro en bucle en exploración")
	check(app.exploration_footer.visible and app.observation.text.begins_with("Toca los puntos de luz"), "Primera entrada conserva la ayuda para explorar")
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
	var before_interrupted_message: Dictionary = state.data.duplicate(true)
	state.data.messages.append("encargo")
	app.show_device("Mensajes", "La Jefa")
	check(state.data.missions.retorno_agua == "AVAILABLE", "Reabrir un mensaje leído recupera una oferta interrumpida")
	state.data = before_interrupted_message
	check(state.save_game(), "El ensayo de recuperación conserva la partida inicial")
	app.close_modal()
	app.show_exploration()
	await frames()
	await press("Pistas")
	check(app.overlay.visible, "Pistas abre acciones accesibles")
	check(app.modal_body.size.x < app.overlay.size.x * 0.55, "Pistas deja visible la escena")
	check(not app.modal_body.get_parent().get_v_scroll_bar().visible, "Pistas muestra las acciones actuales sin barra de desplazamiento")
	for button in all_buttons(app.overlay):
		if button.text in ["Deck externo", "Cerrar ×"]:
			check(button.get_theme_stylebox("normal") is StyleBoxEmpty, "Acción de Pistas sin recuadro: " + button.text)
	await capture("pistas_1280x720")
	await press("Ocultar puntos de luz")
	check(not app.current_view.spots[0].get_child(0).visible, "Pistas oculta marcas sin desactivar hotspots")
	await press("Mostrar puntos de luz")
	check(app.current_view.spots[0].get_child(0).visible, "Pistas recupera marcas discretas")
	await press("Deck externo", app.overlay)
	check(app.overlay.visible and app.modal_body.get_child_count() > 0, "Acción nombrada de Pistas abre el deck")
	await press("Cerrar ×")
	await press("· Deck externo")
	check(app.overlay.visible, "Hotspot abre deck con ratón")
	check(has_button("La Jefa · 1 nuevo", app.overlay) and has_button("Madre · 1 nuevo", app.overlay), "Mensajes agrupados por contacto con indicador sin leer")
	check(not has_button("Enlace policial · 1 nuevo", app.overlay) and not has_button("Hermana · 1 nuevo", app.overlay), "Mensajes futuros aún ocultos")
	check(app.deck_unread_label.text == "2", "Indicador del deck muestra dos mensajes iniciales")
	await press("Madre · 1 nuevo")
	check("madre_inicio" in state.data.messages and state.data.missions.retorno_agua == "LOCKED", "Leer a la madre no activa un contrato")
	await press("Responder: Estoy bien. Hasta he desayunado.")
	check(state.data.choices.get("message:madre_inicio") == "broma" and not state.reply_to_message("madre_inicio", "breve"), "Respuesta familiar guardada una sola vez")
	await capture("v0_2_chat_1280x720")
	root.size = Vector2i(844, 390)
	await frames(8)
	await capture("v0_2_chat_844x390")
	root.size = Vector2i(1280, 720)
	await frames(8)
	await press("Volver a mensajes")
	await press("La Jefa · 1 nuevo")
	check(state.data.missions.retorno_agua == "AVAILABLE", "Mensaje recibe contrato")
	await press("Revisar contrato")
	var tabs := all_buttons(app.overlay)
	var first_tab: Button
	var second_tab: Button
	for button in tabs:
		if button.text == "Mensajes": first_tab = button
		if button.text == "Contratos": second_tab = button
	check(first_tab != null and second_tab != null and second_tab.get_global_rect().position.x - first_tab.get_global_rect().end.x >= 12, "Pestañas del deck separadas")
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
	check(state.unread_messages().has("hermana_grupo"), "La hermana escribe tras la lectura doméstica")
	await press("Deck")
	await press("Hermana · 1 nuevo")
	await press("Responder: Tiene pulso. Pásame el resto.")
	check(state.data.choices.get("message:hermana_grupo") == "gusta", "Opinión musical guardada")
	await press("Cerrar ×")
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
	check(app.get("ambience_player") is AudioStreamPlayer and app.ambience_player.stream is AudioStreamWAV and app.ambience_player.pitch_scale == 1.0, "Ambiente cambia con la zona")
	await capture("10_fiebre")
	await press("> Umbral de Velvet")
	check(state.data.screen == "fiebre_entrada", "Entrada física al umbral de Velvet")
	await press("> Volver al pasaje", null, true)
	check(state.data.screen == "fiebre_calle", "Regreso táctil desde el umbral")
	await press("> Rincón de trato")
	check(state.data.screen == "fiebre_encuentro", "Rincón de trato navegable")
	await press("> Volver al pasaje")
	await press("> Galería de residentes")
	check(state.data.screen == "fiebre_galeria", "Galería navegable")
	await press("> Pasarela de suministros", null, true)
	check(state.data.screen == "fiebre_suministros", "Pasarela accesible por toque")
	await press("> Volver a la galería")
	await press("> Control de descenso")
	check(state.data.screen == "fiebre_descenso", "Control de descenso navegable")
	check(not state.travel_reason("nudo_acceso").is_empty(), "El Nudo aún conserva el límite del hito")
	await press("> Volver al pasaje")
	check(state.data.screen == "fiebre_calle", "Regreso del control al pasaje")
	await press("· Hablar con la Jefa")
	await capture("11_dialogo")
	var dialogue = app.overlay.get_child(0)
	check(dialogue.content.other == "jefa", "Interlocutora original")
	var dialogue_center: VBoxContainer = dialogue.column.get_parent().get_parent()
	for portrait in [dialogue.sota, dialogue.other]:
		check(portrait_floor_gap(portrait, dialogue.get_global_rect().end.y) <= 28.0, "Retrato apoyado abajo en escritorio: " + portrait.texture.resource_path)
		check(dialogue_center.global_position.y >= portrait.global_position.y - 72.0 and dialogue_center.global_position.y <= portrait.global_position.y + 28.0, "Conversación empieza junto al retrato en escritorio: " + portrait.texture.resource_path)
	await capture("v0_2_dialogo_1280x720")
	root.size = Vector2i(844, 390)
	await frames(8)
	for portrait in [dialogue.sota, dialogue.other]:
		check(portrait_floor_gap(portrait, dialogue.get_global_rect().end.y) <= 28.0, "Retrato apoyado abajo en horizontal móvil: " + portrait.texture.resource_path)
		check(dialogue_center.global_position.y >= portrait.global_position.y - 72.0 and dialogue_center.global_position.y <= portrait.global_position.y + 28.0, "Conversación empieza junto al retrato en horizontal móvil: " + portrait.texture.resource_path)
	await capture("v0_2_dialogo_844x390")
	root.size = Vector2i(1280, 720)
	await frames(8)
	var choice: Dictionary = content.dialogues.jefa.nodes.saludo.choices[2]
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
	check(app.exploration_footer.visible and app.observation.text.begins_with("El parte y la lectura están guardados"), "El cierre del diálogo informa una vez")
	await press("×")
	await press("Deck")
	check(has_button("La Jefa · 1 nuevo", app.overlay) and has_button("Lía · 1 nuevo", app.overlay), "Contacto directo y amiga llegan tras el encuentro")
	await press("La Jefa · 1 nuevo")
	await press("Responder: Contacto guardado. Si surge algo, dime qué necesitas.")
	check(state.data.flags.get("contacto_jefa_guardado", false), "Contacto directo de la Jefa guardado")
	await press("Volver a mensajes")
	await press("Contactos")
	check(has_button("La Jefa", app.overlay), "La Jefa aparece entre contactos al guardarla")
	await press("Mensajes")
	await press("Lía · 1 nuevo")
	await press("Responder: Volveré. No prometo la hora.")
	check(state.data.choices.get("message:lia_pasaje") == "volvere", "Respuesta a Lía guardada")
	await press("Cerrar ×")
	await press("> Volver a casa")
	check(app.exploration_footer.visible and app.observation.text == "Vuelves por el pasaje hasta tu puerta.", "El trayecto conserva su aviso propio")
	await press("> Baño")
	check(not app.exploration_footer.visible and app.observation_timer.is_stopped(), "Cambiar de habitación no repite el estado del contrato")
	await capture("navegacion_sin_aviso")
	await press("> Salón / cocina")
	check(state.data.screen == "ap_cocina", "Regreso del baño a cocina tras captura: " + state.data.screen)
	await press("> Salir a La Fiebre")
	await press("> Control de descenso")
	await press("> Bajar a El Nudo")
	check(state.data.screen == "nudo_acceso", "Bajada autorizada hasta El Nudo")
	await press("> Taller de reparaciones")
	check(state.data.screen == "nudo_taller", "Taller de El Nudo navegable")
	await press("· Ficha del equipo")
	check(state.data.flags.get("equipo_comprobado", false), "Ficha del equipo comprobada en El Nudo")
	await press("Cerrar documento")
	await press("> Puesto de red", null, true)
	check(state.data.screen == "nudo_terminal", "Puesto de red accesible por toque")
	await press("> Archivo de órdenes")
	await press("> Paso inferior")
	check(state.data.screen == "nudo_paso_inferior", "Paso inferior navegable")
	state.data.flags.erase("orden_visita")
	check(not state.navigate("puntales_acceso"), "Bajada a Los Puntales sin orden bloqueada")
	state.apply({"flag": "orden_visita"})
	await press("> Bajar a Los Puntales")
	check(state.data.screen == "puntales_acceso", "Bajada autorizada a Los Puntales")
	await press("> Taller de conducción")
	await press("> Frente de trabajo")
	await press("> Galería de soportes", null, true)
	await press("> Cámara de presión")
	await press("> Puesto de verificación")
	check(state.data.screen == "puntales_verificacion", "Anillo de Los Puntales accesible por toque")
	await press("· Control de la conducción")
	check(state.data.missions.retorno_agua == "READY_TO_COMPLETE", "El parte queda listo con prueba física")
	await press("Cerrar documento")
	await press("> Acceso a Los Puntales")
	await press("> Subir a El Nudo")
	check(state.data.screen == "nudo_paso_inferior", "Subida autorizada a El Nudo")
	await press("> Archivo de órdenes")
	await press("> Mercado de componentes")
	check(state.data.screen == "nudo_mercado", "Mercado de componentes navegable")
	await press("> Acceso a El Nudo")
	state.data.flags.erase("acreditacion_residencia")
	check(not state.navigate("fiebre_descenso"), "Subida sin acreditación bloqueada")
	state.apply({"flag": "acreditacion_residencia"})
	await press("> Subir a La Fiebre")
	check(state.data.screen == "fiebre_descenso", "Subida con acreditación autorizada")
	await press("> Volver al pasaje")
	check(state.data.missions.retorno_agua == "READY_TO_COMPLETE", "La comprobación exige entrega explícita")
	await press("· Hablar con la Jefa")
	await press("Entregar la comprobación del agua.")
	await press("Continuar >")
	await press("Guardar la conclusión")
	check(state.data.missions.retorno_agua == "COMPLETED" and not app.exploration_footer.visible, "Primer contrato entregado sin aviso repetido")
	await press("Deck")
	check(has_button("Enlace policial · 1 nuevo", app.overlay), "La policía escribe tras el primer contrato")
	await press("Enlace policial · 1 nuevo")
	await press("Revisar contrato")
	await press("Aceptar contrato")
	check(state.data.missions.orden_duplicada == "ACTIVE", "Segundo contrato aceptado: " + JSON.stringify(state.data.missions))
	await press("Cerrar ×")
	for label in ["> Galería de residentes", "> Pasarela de suministros"]:
		await press(label)
	await press("· Remesa de filtros")
	await press("Cerrar documento")
	for label in ["> Volver a la galería", "> Control de descenso", "> Bajar a El Nudo", "> Taller de reparaciones", "> Puesto de red", "> Archivo de órdenes"]:
		await press(label)
	await press("· Orden duplicada")
	await press("Cerrar documento")
	await press("> Puesto de red")
	await press("· Puesto de red")
	await press("Leer traza de transmisión")
	check(state.data.missions.orden_duplicada == "READY_TO_COMPLETE", "Segundo contrato reúne tres pruebas")
	await press("Cerrar documento")
	await press("· Puesto de red")
	await press("Redactar y enviar informe policial")
	await press("Enviar el informe de hechos.")
	await press("Guardar el acuse")
	check(state.data.missions.orden_duplicada == "COMPLETED", "Informe policial entregado")
	await press("Deck")
	check(has_button("La Jefa · 1 nuevo", app.overlay) and has_button("Madre · 1 nuevo", app.overlay), "Tercer encargo y mensaje familiar tras el informe")
	root.size = Vector2i(844, 390)
	await frames(8)
	await press("Madre · 1 nuevo")
	await frames(4)
	check((app.modal_body.get_parent() as ScrollContainer).scroll_vertical > 0, "El hilo lleva al nuevo mensaje familiar en horizontal móvil")
	await press("Responder: Sí. Estoy cuidándome.")
	check(state.data.choices.get("message:madre_seguimiento") == "bien", "Respuesta al seguimiento familiar guardada en móvil")
	root.size = Vector2i(1280, 720)
	await frames(8)
	await press("Volver a mensajes")
	await press("La Jefa · 1 nuevo")
	await press("Revisar contrato")
	await press("Aceptar contrato")
	check(state.data.missions.prueba_presion == "ACTIVE", "Tercer contrato aceptado")
	root.size = Vector2i(844, 390)
	app.show_device("Contratos")
	await frames(8)
	await capture("v1_contratos_844x390")
	root.size = Vector2i(1280, 720)
	await press("Cerrar ×")
	for label in ["> Taller de reparaciones", "> Acceso a El Nudo", "> Subir a La Fiebre", "> Volver a la galería"]:
		await press(label)
	await press("· Lista de cargos")
	await press("Cerrar documento")
	for label in ["> Control de descenso", "> Bajar a El Nudo", "> Mercado de componentes", "> Archivo de órdenes", "> Paso inferior", "> Bajar a Los Puntales", "> Puesto de verificación", "> Cámara de presión", "> Galería de soportes"]:
		await press(label)
	await press("· Marca del soporte")
	await press("Cerrar documento")
	await press("> Cámara de presión")
	await press("· Lectura de presión")
	await press("Cerrar documento")
	check(state.data.missions.prueba_presion == "READY_TO_COMPLETE", "Tercer contrato listo para cerrar")
	for label in ["> Puesto de verificación", "> Acceso a Los Puntales", "> Subir a El Nudo", "> Archivo de órdenes", "> Mercado de componentes", "> Acceso a El Nudo", "> Subir a La Fiebre", "> Volver al pasaje"]:
		await press(label)
	var before_final: Dictionary = state.data.duplicate(true)
	await press("· Hablar con la Jefa")
	await press("Entregar las copias de la prueba final.")
	await press("Informar primero a las viviendas afectadas.")
	check(state.data.missions.prueba_presion == "READY_TO_COMPLETE" and not state.data.flags.get("vecinos_primero", false), "Elegir destinatario aún permite releer el último parlamento")
	await press("Volver a la escena")
	check(state.data.missions.prueba_presion == "READY_TO_COMPLETE" and not app.overlay.visible, "Salir antes del cierre conserva el contrato entregable")
	await press("· Hablar con la Jefa")
	await press("Entregar las copias de la prueba final.")
	await press("Informar primero a las viviendas afectadas.")
	await press("Cerrar la historia")
	check(state.data.missions.prueba_presion == "COMPLETED" and state.data.flags.get("vecinos_primero", false), "Final de viviendas registrado")
	check(app.overlay.visible and has_button("Cierre", app.overlay), "El cierre se abre automáticamente tras terminar")
	await capture("v1_cierre_1280x720")
	root.size = Vector2i(844, 390)
	app.show_device("Cierre")
	await frames(8)
	await capture("v1_cierre_844x390")
	root.size = Vector2i(1280, 720)
	await press("Cerrar ×")
	state.data = before_final
	check(state.save_game(), "Estado previo al final conservado para probar segunda decisión")
	app.show_exploration()
	await press("· Hablar con la Jefa")
	await press("Entregar las copias de la prueba final.")
	await press("Enviar primero las copias al canal policial.")
	await press("Cerrar la historia")
	check(state.data.missions.prueba_presion == "COMPLETED" and state.data.flags.get("policia_primero", false) and not state.data.flags.get("vecinos_primero", false), "Final policial registrado sin mezclar decisiones")
	check(app.overlay.visible and has_button("Cierre", app.overlay), "El cierre policial se abre automáticamente")
	check(state.unread_messages().has("lia_cierre"), "Lía vuelve a escribir tras el final")
	app.show_device()
	await press("Lía · 1 nuevo")
	await press("Responder: Voy cuando cierre el deck.")
	check(state.data.choices.get("message:lia_cierre") == "ir", "Respuesta final a Lía guardada")
	await press("Volver a mensajes")
	await press("Madre · al día")
	check(state.data.choices.get("message:madre_inicio") == "broma", "La respuesta previa persiste en el hilo familiar")
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
	check(not app.exploration_footer.visible, "Continuar no repite el estado del contrato")
	# Datos truncados, versiones futuras y estructuras mal tipadas.
	for invalid in [null, [], {"version":999}, {"version":1}, {"version":1,"screen":[]}]:
		check(not state.valid(invalid), "Guardado inválido rechazado")
	var malformed: Dictionary = snapshot.duplicate(true)
	malformed.documents = [42]
	check(not state.valid(malformed), "IDs de documento inválidos")
	var missing_original: Dictionary = snapshot.duplicate(true)
	missing_original.missions.erase("retorno_agua")
	check(not state.valid(missing_original), "Guardado sin misión original rechazado")
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
			await press("Pistas")
			var hints_scroll := app.modal_body.get_parent() as ScrollContainer
			check(hints_scroll.get_global_rect().end.x <= app.overlay.get_global_rect().end.x and hints_scroll.get_global_rect().end.y <= app.overlay.get_global_rect().end.y, "Pistas cabe en móvil horizontal")
			check(hints_scroll.get_v_scroll_bar().visible, "Pistas desplaza sus acciones adicionales en móvil")
			await capture("pistas_844x390")
			await press("Cerrar ×")
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
	check(state.data.missions.retorno_agua == "COMPLETED" and state.data.missions.orden_duplicada == "COMPLETED" and state.data.missions.prueba_presion == "COMPLETED", "Las tres misiones siguen completas tras carga")
	for resolution in [Vector2i(1280, 720), Vector2i(844, 390)]:
		root.size = resolution
		for sid in fiebre_ids + nudo_ids + puntales_ids:
			if sid == "fiebre_calle" or not content.world.screens.has(sid) or not content.world.screens[sid].implemented:
				continue
			state.data.screen = sid
			state.data.zone = content.world.screens[sid].zone
			app.show_exploration()
			await frames(8)
			check(app.current_view.image.texture != null, "Textura visible " + sid)
			for spot in app.current_view.spots:
				check(app.current_view.art_rect().encloses(Rect2(spot.position, spot.size)), "Hotspot visible " + sid + " " + str(resolution))
			await capture("zona_%s_%dx%d" % [sid, resolution.x, resolution.y])
			if resolution == Vector2i(844, 390) and sid in ["nudo_acceso", "puntales_acceso"]:
				await press("Pistas")
				check(app.overlay.visible and app.modal_body.get_global_rect().end.y <= app.overlay.get_global_rect().end.y, "Pistas de " + sid + " cabe en móvil horizontal")
				await capture("zona_%s_pistas_844x390" % sid)
				await press("Cerrar ×")
	state.new_game()
	check(state.data.documents.is_empty() and state.data.discoveries.is_empty() and state.data.choices.is_empty(), "Nueva partida limpia progreso")
	for filename in DirAccess.get_files_at("user://"):
		if filename.begins_with("prueba_" + str(OS.get_process_id())):
			DirAccess.remove_absolute("user://" + filename)
	app.ambience_player.stop()
	app.queue_free()
	await frames(2)
	print("RESULTADO: %d comprobaciones, %d fallos" % [count, failures.size()])
	quit(0 if failures.is_empty() else 1)
