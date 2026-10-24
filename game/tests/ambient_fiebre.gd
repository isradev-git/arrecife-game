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
	if is_instance_valid(app.opening):
		app.opening.hide()
	app.show_exploration()
	await process_frame
	var open_view: Control = app.current_view
	var options_button: Button
	for button in app.exploration_header.find_children("*", "Button", true, false):
		if button.text == "Opciones":
			options_button = button
	check(options_button != null, "La exploración ofrece Opciones sin salir al menú")
	if options_button:
		var options_hit := options_button.get_global_rect().get_center()
		for down in [true, false]:
			var event := InputEventMouseButton.new()
			event.position = options_hit
			event.button_index = MOUSE_BUTTON_LEFT
			event.pressed = down
			root.push_input(event, true)
			for frame in 3:
				await process_frame
		check(app.overlay.visible and app.current_view == open_view, "Opciones se abre sobre la misma vista")
	var motion_check: CheckButton
	if app.modal_body:
		for candidate in app.modal_body.find_children("*", "CheckButton", true, false):
			if candidate.text == "Reducir movimiento":
				motion_check = candidate
	check(motion_check != null, "Opciones describe el movimiento ambiental")
	if motion_check:
		motion_check.button_pressed = true
		check(not app.current_view.ambient.visible and not app.current_view.ambient.is_processing(), "Opciones detiene la vista abierta al instante")
		motion_check.button_pressed = false
		check(app.current_view.ambient.visible and app.current_view.ambient.is_processing(), "Opciones reanuda la vista abierta")
	if OS.get_environment("ARRECIFE_AMBIENT_CAPTURE") == "1" and DisplayServer.get_name() != "headless":
		app.close_modal()
		var capture_dir := ProjectSettings.globalize_path("res://build/ambient")
		DirAccess.make_dir_recursive_absolute(capture_dir)
		for dimensions in [Vector2i(1280, 720), Vector2i(844, 390)]:
			root.size = dimensions
			for frame in 8:
				await process_frame
			for moment in [0.0, 2.1]:
				app.current_view.ambient.elapsed = moment
				app.current_view.ambient.queue_redraw()
				await process_frame
				RenderingServer.force_draw()
				check(root.get_texture().get_image().save_png(capture_dir.path_join("fiebre_%dx%d_%.1f.png" % [dimensions.x, dimensions.y, moment])) == OK, "Captura ambiental %s, %.1f" % [dimensions, moment])
			app.current_view.set_ambient_motion(false)
			await process_frame
			RenderingServer.force_draw()
			check(root.get_texture().get_image().save_png(capture_dir.path_join("fiebre_%dx%d_reducido.png" % [dimensions.x, dimensions.y])) == OK, "Captura con movimiento reducido " + str(dimensions))
			app.current_view.set_ambient_motion(true)
		if OS.get_environment("ARRECIFE_AMBIENT_CLIP") == "1":
			var frames_dir := capture_dir.path_join("frames")
			DirAccess.make_dir_recursive_absolute(frames_dir)
			for frame in 48:
				app.current_view.ambient.elapsed = float(frame) * 0.125
				app.current_view.ambient.queue_redraw()
				await process_frame
				RenderingServer.force_draw()
				check(root.get_texture().get_image().save_png(frames_dir.path_join("%03d.png" % frame)) == OK, "Fotograma ambiental " + str(frame))
	app.queue_free()
	state.data = original_data
	state.set_option("reduced_motion", original_motion)
	for frame in 3:
		await process_frame
	await create_timer(0.1).timeout
	print("AMBIENTE: %d comprobaciones, %d fallos" % [checks, failures.size()])
	quit(0 if failures.is_empty() else 1)
