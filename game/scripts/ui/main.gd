extends Control

const Viewpoint = preload("res://scripts/ui/viewpoint.gd")
const Dialogue = preload("res://scripts/ui/dialogue.gd")
const Device = preload("res://scripts/ui/device.gd")
const Startup = preload("res://scripts/ui/startup.gd")
const OBSERVATION_SECONDS := 14.0
var page := Control.new()
var overlay := Control.new()
var observation_timer := Timer.new()
var orientation_gate := Startup.new()
var opening
var current_view: Control
var observation: Label
var location_label: Label
var menu_visible := true
var intro_index := 0
var modal_body: VBoxContainer
var focus_before_modal: Control
var exploration_header: BoxContainer
var exploration_footer: PanelContainer
var ambience_player := AudioStreamPlayer.new()
var touch_player := AudioStreamPlayer.new()

func _ready() -> void:
	theme = GameUI.theme()
	resized.connect(reflow)
	get_window().size_changed.connect(update_scale)
	update_scale()
	add_child(page)
	GameUI.fill(page)
	add_child(overlay)
	GameUI.fill(overlay)
	overlay.hide()
	ambience_player.bus = "Music"
	ambience_player.volume_db = -7.0
	ambience_player.stream = load("res://assets/audio/arrecife_ambiente.wav")
	if ambience_player.stream is AudioStreamWAV:
		ambience_player.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	add_child(ambience_player)
	touch_player.bus = "Effects"
	touch_player.stream = load("res://assets/audio/arrecife_toque.wav")
	add_child(touch_player)
	observation_timer.one_shot = true
	observation_timer.timeout.connect(dismiss_observation)
	add_child(observation_timer)
	orientation_gate.orientation_only = true
	add_child(orientation_gate)
	GameUI.fill(orientation_gate)
	orientation_gate.hide()
	State.save_failed.connect(func(message: String): show_notice("Guardado pendiente", message))
	if should_show_opening():
		opening = Startup.new()
		add_child(opening)
		GameUI.fill(opening)
		opening.finished.connect(func():
			opening.queue_free()
			show_menu()
			orientation_gate.refresh())
		menu_visible = false
	else:
		show_menu()
		orientation_gate.refresh()

func should_show_opening() -> bool:
	if not OS.has_feature("web"):
		return true
	# sessionStorage sobrevive a recargas, pero se borra al cerrar la pestaña.
	var result = JavaScriptBridge.eval("(function(){try{var s=sessionStorage,k='el_arrecife_apertura_v1';if(s.getItem(k)==='1')return 0;s.setItem(k,'1');return 1}catch(e){return 1}})()")
	return result == 1 or result == null

func reflow() -> void:
	if is_instance_valid(current_view):
		current_view.layout_spots()

func update_scale() -> void:
	var portrait := get_window().size.x < get_window().size.y
	var target := Vector2i(480, 540) if portrait else (Vector2i(780, 440) if get_window().size.y < 500 else Vector2i(960, 540))
	if get_window().content_scale_size != target:
		get_window().content_scale_size = target
	if is_instance_valid(opening) and opening.is_inside_tree():
		opening.refresh()
	if orientation_gate.is_inside_tree():
		orientation_gate.refresh()

func background(parent: Control, id: String, dim: float = 0.0) -> void:
	var texture := TextureRect.new()
	texture.texture = load("res://assets/backgrounds/candidates/%s.png" % id)
	texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(texture)
	GameUI.fill(texture)
	var shade := ColorRect.new()
	shade.color = Color(0.02,0.035,0.045,dim)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(shade)
	GameUI.fill(shade)

func show_menu() -> void:
	ambience_player.stop()
	dismiss_observation()
	close_modal()
	menu_visible = true
	GameUI.clear(page)
	background(page, "menu_nudo_ventana_v3")
	var margins := GameUI.margin(page, 42)
	GameUI.fill(margins)
	var row := HBoxContainer.new()
	margins.add_child(row)
	var column := VBoxContainer.new()
	column.custom_minimum_size.x = 220
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	row.add_child(column)
	GameUI.label(column, "EL ARRECIFE", 30)
	var links := VBoxContainer.new()
	column.add_child(links)
	menu_link(links, "Jugar", request_new_game)
	var continue_button := menu_link(links, "Continuar", continue_game)
	continue_button.disabled = not State.has_save()
	menu_link(links, "Opciones", show_options)
	menu_link(links, "Créditos", show_credits)
	if FileAccess.file_exists(State.save_path) and not State.has_save():
		GameUI.label(column, "Guardado incompatible o dañado conservado. Puedes iniciar otra partida.", 18)

func menu_link(parent: Node, title: String, action: Callable) -> Button:
	var link := Button.new()
	link.text = title
	link.alignment = HORIZONTAL_ALIGNMENT_LEFT
	link.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	link.custom_minimum_size.y = 36 if get_window().size.y >= 500 else 48
	link.add_theme_font_size_override("font_size", 18 if get_window().size.y < 500 else 15)
	link.focus_mode = Control.FOCUS_ALL
	for state in ["normal", "hover", "pressed", "disabled"]:
		link.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = GameUI.AMBER
	focus.border_width_bottom = 2
	link.add_theme_stylebox_override("focus", focus)
	link.add_theme_color_override("font_color", GameUI.PAPER)
	link.add_theme_color_override("font_hover_color", GameUI.AMBER)
	link.add_theme_color_override("font_disabled_color", GameUI.MUTED.darkened(0.4))
	link.pressed.connect(action)
	parent.add_child(link)
	return link

func request_new_game() -> void:
	if FileAccess.file_exists(State.save_path) or FileAccess.file_exists(State.save_path + ".bak"):
		open_panel("Empezar otra historia", "NUEVA PARTIDA", false, true, 280)
		GameUI.label(modal_body, "Se reiniciará el progreso activo. La partida anterior quedará como copia local de respaldo.")
		GameUI.button(modal_body, "Empezar de nuevo", start_new_game)
	else:
		start_new_game()

func start_new_game() -> void:
	close_modal()
	if not State.new_game():
		show_notice("No se pudo iniciar", State.last_error)
		return
	intro_index = 0
	show_intro()

func continue_game() -> void:
	if State.load_game():
		var notice := State.last_error
		show_exploration()
		if not notice.is_empty():
			observe(notice)
	else:
		show_notice("No se pudo continuar", State.last_error)

func show_intro() -> void:
	ambience_player.stop()
	dismiss_observation()
	menu_visible = false
	GameUI.clear(page)
	background(page, "dormitorio", 0.84)
	var margins := GameUI.margin(page, 64)
	GameUI.fill(margins)
	var column := VBoxContainer.new()
	margins.add_child(column)
	var entry: Dictionary = Content.story.intro[intro_index]
	GameUI.label(column, "%02d / %02d" % [intro_index+1, Content.story.intro.size()], 18).modulate = GameUI.AMBER
	GameUI.label(column, entry.heading, 48)
	var body := GameUI.scroll(column)
	GameUI.label(body, entry.text, 28)
	GameUI.button(column, "Entrar" if intro_index == Content.story.intro.size()-1 else "Continuar", func():
		intro_index += 1
		if intro_index >= Content.story.intro.size():
			enter_exploration()
		else:
			show_intro())
	GameUI.button(column, "Saltar introducción", enter_exploration)

func enter_exploration() -> void:
	show_exploration()
	observe("Toca los puntos de luz para explorar. El deck contiene un mensaje nuevo.")

func show_exploration() -> void:
	dismiss_observation()
	close_modal()
	menu_visible = false
	GameUI.clear(page)
	current_view = Viewpoint.new()
	page.add_child(current_view)
	GameUI.fill(current_view)
	current_view.activated.connect(interact)
	var screen: Dictionary = Content.world.screens[State.data.screen]
	ambience_player.pitch_scale = {"apartamento": 0.9, "fiebre": 1.0, "nudo": 0.82, "puntales": 0.68}[screen.zone]
	if not ambience_player.playing:
		ambience_player.play()
	current_view.show_screen(screen)
	var top := PanelContainer.new()
	top.add_theme_stylebox_override("panel", GameUI.box(Color(0.035, 0.065, 0.08, 0.88)))
	page.add_child(top)
	top.anchor_right = 1
	top.offset_left = 8
	top.offset_top = 8
	top.offset_right = -8
	top.offset_bottom = 50
	var header := HBoxContainer.new()
	exploration_header = header
	top.add_child(header)
	var heading := VBoxContainer.new()
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(heading)
	location_label = GameUI.label(heading, screen.subtitle, 20)
	var controls := HBoxContainer.new()
	header.add_child(controls)
	controls.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	GameUI.button(controls, "Deck", func(): show_device())
	GameUI.button(controls, "Pistas", show_hints_panel)
	GameUI.button(controls, "Menú", func():
		State.save_game()
		show_menu())
	var footer := PanelContainer.new()
	exploration_footer = footer
	footer.add_theme_stylebox_override("panel", GameUI.box(Color(0.04, 0.08, 0.10, 0.86)))
	page.add_child(footer)
	footer.hide()
	footer.anchor_left = 0
	footer.anchor_right = 1
	footer.anchor_top = 1
	footer.anchor_bottom = 1
	footer.offset_left = 8
	footer.offset_right = -8
	footer.offset_top = -118 if get_window().size.y < 500 else -104
	footer.offset_bottom = -8
	var footer_row := HBoxContainer.new()
	footer.add_child(footer_row)
	var footer_column := GameUI.scroll(footer_row)
	observation = GameUI.label(footer_column, "", 20)
	var close_observation := Button.new()
	close_observation.text = "×"
	close_observation.tooltip_text = "Cerrar observación"
	close_observation.accessibility_name = "Cerrar observación"
	close_observation.custom_minimum_size = Vector2(40, 40)
	close_observation.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	close_observation.add_theme_font_size_override("font_size", 23)
	for state in ["normal", "hover", "pressed"]:
		close_observation.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	close_observation.add_theme_color_override("font_hover_color", GameUI.AMBER)
	close_observation.pressed.connect(dismiss_observation)
	footer_row.add_child(close_observation)

func show_hints_panel() -> void:
	open_panel("Pistas", "", false, true, 375)
	for spot in current_view.get("spots"):
		var hotspot: Dictionary = spot.get_meta("hotspot")
		GameUI.action(modal_body, hotspot.label, func():
			close_modal()
			interact(hotspot))
	modal_body.add_child(HSeparator.new())
	GameUI.action(modal_body, "Ocultar puntos de luz" if State.settings.hints else "Mostrar puntos de luz", func():
		State.set_option("hints", not State.settings.hints)
		current_view.set_hints(State.settings.hints)
		show_hints_panel())

func observe(text: String) -> void:
	if is_instance_valid(observation) and is_instance_valid(exploration_footer):
		observation.text = text
		exploration_footer.show()
		observation_timer.start(OBSERVATION_SECONDS)

func dismiss_observation() -> void:
	observation_timer.stop()
	if is_instance_valid(exploration_footer):
		exploration_footer.hide()

func interact(hotspot: Dictionary) -> void:
	touch_player.play()
	if not State.matches(hotspot.get("available_if", {})):
		observe(hotspot.get("locked_text", "Todavía no está disponible."))
		return
	match hotspot.type:
		"OBJECT": observe(Content.story.observations[hotspot.target])
		"NAVIGATION", "SPECIAL_EVENT": travel(hotspot.target)
		"DEVICE": show_device()
		"DOCUMENT": show_document(hotspot.target)
		"TERMINAL": show_terminal(hotspot.target)
		"PERSON": show_dialogue(hotspot.target)

func travel(target: String) -> void:
	var reason := State.travel_reason(target)
	if not reason.is_empty():
		show_notice("El trayecto", reason)
		return
	var from: String = State.data.zone
	var to: String = Content.world.screens[target].zone
	var text := ""
	for route in Content.world.routes:
		if route.from == from and route.to == to:
			text = route.text
	if State.navigate(target):
		show_exploration()
		if not text.is_empty():
			observe(text)
		if not State.settings.reduced_motion:
			page.modulate.a = 0.35
			create_tween().tween_property(page, "modulate:a", 1.0, 0.25)

func close_modal() -> void:
	GameUI.clear(overlay)
	overlay.hide()
	if is_instance_valid(focus_before_modal):
		focus_before_modal.grab_focus()

func open_panel(title: String, eyebrow: String = "DECK EXTERNO / ENLACE LOCAL", paper: bool = false, compact: bool = false, compact_height: int = 350) -> void:
	if not overlay.visible:
		focus_before_modal = get_viewport().gui_get_focus_owner()
	GameUI.clear(overlay)
	overlay.show()
	var dim := ColorRect.new()
	dim.color = Color(0.015,0.025,0.035,0.42 if compact else 0.68)
	overlay.add_child(dim)
	GameUI.fill(dim)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", GameUI.box(Color("d5c8aa") if paper else Color("10242a"), Color("50646a")))
	overlay.add_child(panel)
	if compact:
		panel.position = Vector2(24, 24)
		panel.size = Vector2(360, compact_height)
	else:
		panel.anchor_left = 0.13
		panel.anchor_top = 0.12
		panel.anchor_right = 0.87
		panel.anchor_bottom = 0.88
	var column := VBoxContainer.new()
	panel.add_child(column)
	if not eyebrow.is_empty():
		GameUI.label(column, eyebrow, 16).modulate = Color("33484a") if paper else GameUI.AMBER
	var row := HBoxContainer.new()
	column.add_child(row)
	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title_box)
	GameUI.label(title_box, title, 30).modulate = Color("293336") if paper else Color.WHITE
	var close := GameUI.action(row, "Cerrar ×", close_modal)
	close.size_flags_horizontal = Control.SIZE_SHRINK_END
	close.grab_focus()
	modal_body = GameUI.scroll(column)
	if paper:
		modal_body.add_theme_color_override("font_color", Color("18252b"))

func show_notice(title: String, text: String) -> void:
	open_panel(title, "EL ARRECIFE")
	GameUI.label(modal_body, text, 26)

func show_dialogue(id: String) -> void:
	var had_part: bool = State.data.flags.get("parte_contrastado", false)
	var had_final: bool = State.data.missions.get("prueba_presion") == "COMPLETED"
	focus_before_modal = get_viewport().gui_get_focus_owner()
	GameUI.clear(overlay)
	overlay.show()
	var dialogue := Dialogue.new()
	overlay.add_child(dialogue)
	GameUI.fill(dialogue)
	dialogue.finished.connect(func():
		close_modal()
		if not had_final and State.data.missions.get("prueba_presion") == "COMPLETED":
			show_device("Cierre")
		elif not had_part and State.data.flags.get("parte_contrastado", false):
			observe("El parte y la lectura están guardados. El siguiente contraste corresponde al equipo de El Nudo."))
	dialogue.start(id)

func show_document(id: String, page_number: int = 0) -> void:
	var document: Dictionary = Content.story.documents[id]
	State.apply({"document": id})
	State.apply(document.get("effects", {}))
	open_panel(document.title, document.issuer, true)
	GameUI.label(modal_body, document.pages[page_number], 28 if State.settings.large_text else 24).add_theme_color_override("font_color", Color("18252b"))
	GameUI.label(modal_body, "PÁGINA %d / %d · COPIA GUARDADA EN EL DECK" % [page_number+1, document.pages.size()], 16).add_theme_color_override("font_color", Color("35464a"))
	if page_number > 0:
		GameUI.button(modal_body, "< Página anterior", func(): show_document(id, page_number-1))
	if page_number < document.pages.size()-1:
		GameUI.button(modal_body, "Página siguiente >", func(): show_document(id, page_number+1))
	GameUI.button(modal_body, "Cerrar documento", close_modal)

func show_terminal(id: String) -> void:
	var terminal: Dictionary = Content.story.terminals[id]
	open_panel(terminal.title, terminal.status, false, true)
	GameUI.label(modal_body, "*  CONEXIÓN DISPONIBLE\n\nSelecciona un registro local.", 24).modulate = Color("97c2ac")
	for entry in terminal.entries:
		if not State.matches(entry.get("available_if", {})):
			continue
		if entry.has("document"):
			GameUI.action(modal_body, entry.label, func(): show_document(entry.document))
		else:
			GameUI.action(modal_body, entry.label, func(): show_dialogue(entry.dialogue))
	if not State.settings.reduced_motion:
		modal_body.modulate.a = 0.0
		create_tween().tween_property(modal_body, "modulate:a", 1.0, 0.2)

func show_device(tab: String = "Mensajes") -> void:
	open_panel("Deck externo", "MEMORIA LOCAL / PUERTO FÍSICO")
	var device := Device.new()
	modal_body.add_child(device)
	device.show_tab(self, tab)

func show_options() -> void:
	open_panel("Opciones", "AJUSTES LOCALES")
	GameUI.label(modal_body, "Ajustes de sonido y lectura", 20)
	for pair in [["master", "Volumen general"],["music", "Ambiente"],["effects", "Acciones"]]:
		GameUI.label(modal_body, pair[1], 22)
		var slider := HSlider.new()
		slider.min_value = 0
		slider.max_value = 1
		slider.step = 0.05
		slider.value = State.settings[pair[0]]
		slider.custom_minimum_size.y = 60
		slider.value_changed.connect(func(value: float): State.set_option(pair[0], value))
		modal_body.add_child(slider)
	for pair in [["hints", "Mostrar indicadores"],["large_text", "Texto grande en lecturas y diálogos"],["reduced_motion", "Reducir transiciones"]]:
		var check := CheckButton.new()
		check.text = pair[1]
		check.custom_minimum_size.y = 60
		check.button_pressed = State.settings[pair[0]]
		check.toggled.connect(func(value: bool): State.set_option(pair[0], value))
		modal_body.add_child(check)
	GameUI.label(modal_body, "El texto aparece completo, sin espera. En navegador, el guardado depende del almacenamiento local: borrar datos del sitio borra la partida. Evita el modo privado para conservarla.", 20)

func show_credits() -> void:
	open_panel("Créditos", "EL ARRECIFE")
	GameUI.label(modal_body, Content.story.credits, 24)
	GameUI.button(modal_body, "Créditos del motor", func(): show_notice("Godot Engine · MIT", Engine.get_license_text()))
