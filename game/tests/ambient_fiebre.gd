extends SceneTree

var checks := 0
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, description: String) -> void:
	checks += 1
	if not ok:
		failures.append(description)
		push_error("FALLO: " + description)

func run() -> void:
	var script: Script = load("res://scripts/ui/ambient_fiebre.gd")
	check(script != null, "Existe la capa ambiental del pasaje")
	if script:
		var ambient: Control = script.new()
		root.add_child(ambient)
		ambient.size = Vector2(1671, 941)
		check(ambient.mouse_filter == Control.MOUSE_FILTER_IGNORE, "El efecto no intercepta los toques")
		check(ambient.has_method("set_motion_enabled"), "El movimiento se controla desde la vista")
		if ambient.has_method("set_motion_enabled"):
			ambient.set_motion_enabled(true)
			await create_timer(0.12).timeout
			var before: float = ambient.elapsed
			check(before > 0.0 and ambient.visible, "El ambiente avanza cuando está activo")
			ambient.set_motion_enabled(false)
			await create_timer(0.12).timeout
			check(is_equal_approx(ambient.elapsed, before) and not ambient.visible, "Reducir movimiento detiene y oculta el ambiente")
			ambient.set_motion_enabled(true)
			await create_timer(0.12).timeout
			check(ambient.elapsed > before and ambient.visible, "El ambiente se reanuda sin duplicarse")
		ambient.queue_free()
	var state: Node = root.get_node("State")
	var original_data: Dictionary = state.data.duplicate(true)
	var original_motion: bool = state.settings.reduced_motion
	state.data = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/partida_h1_v1.json"))
	var viewpoint_script: Script = load("res://scripts/ui/viewpoint.gd")
	var view: Control = viewpoint_script.new()
	root.add_child(view)
	view.size = Vector2(960, 540)
	var fiebre: Dictionary = root.get_node("Content").world.screens.fiebre_calle
	view.show_screen(fiebre)
	check(view.ambient != null and view.ambient.get_parent() == view.image, "La Fiebre monta la capa sobre la ilustración")
	check(view.get_child(0) == view.image and view.get_child(1) == view.spots[0], "Los hotspots quedan por delante de la capa")
	check(view.ambient.size == view.image.size, "La capa cubre el rectángulo completo del fondo")
	view.size = Vector2(844, 390)
	root.size = Vector2i(844, 390)
	root.content_scale_size = Vector2i(844, 390)
	view.layout_spots()
	await process_frame
	check(view.ambient.size == view.image.size and view.ambient.position == Vector2.ZERO, "El recorte móvil mantiene la alineación")
	view.show_screen(fiebre)
	await process_frame
	check(view.image.get_child_count() == 1, "Reentrar en el pasaje no duplica efectos")
	var activation := {"count": 0}
	view.activated.connect(func(_hotspot: Dictionary): activation.count += 1)
	var hotspot: Button = view.spots[0]
	var hit := hotspot.get_global_rect().get_center()
	var motion := InputEventMouseMotion.new()
	motion.position = hit
	root.push_input(motion, true)
	await process_frame
	check(root.gui_get_hovered_control() == hotspot, "El hotspot recibe el puntero sobre el efecto")
	for down in [true, false]:
		var event := InputEventMouseButton.new()
		event.position = hit
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = down
		root.push_input(event, true)
		for frame in 3:
			await process_frame
	check(activation.count == 1, "El efecto permite pulsar un hotspot situado debajo")
	view.show_screen(root.get_node("Content").world.screens.ap_dormitorio)
	check(view.ambient == null and view.image.get_child_count() == 0, "Otras vistas no conservan el efecto")
	view.queue_free()
	state.data.screen = "fiebre_calle"
	state.data.zone = "fiebre"
	state.set_option("reduced_motion", false)
	var app: Control = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	app.show_exploration()
	app.show_options()
	var motion_check: CheckButton
	for candidate in app.modal_body.find_children("*", "CheckButton", true, false):
		if candidate.text == "Reducir movimiento":
			motion_check = candidate
	check(motion_check != null, "Opciones describe el movimiento ambiental")
	if motion_check:
		motion_check.button_pressed = true
		check(not app.current_view.ambient.visible and not app.current_view.ambient.is_processing(), "Opciones detiene la vista abierta al instante")
		motion_check.button_pressed = false
		check(app.current_view.ambient.visible and app.current_view.ambient.is_processing(), "Opciones reanuda la vista abierta")
	app.queue_free()
	state.data = original_data
	state.set_option("reduced_motion", original_motion)
	for frame in 3:
		await process_frame
	print("AMBIENTE: %d comprobaciones, %d fallos" % [checks, failures.size()])
	quit(0 if failures.is_empty() else 1)
