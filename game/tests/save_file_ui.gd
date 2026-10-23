extends SceneTree

var failures: Array[String] = []
var checks := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, description: String) -> void:
	checks += 1
	if not ok:
		failures.append(description)
		push_error("FALLO: " + description)

func button_exists(node: Node, title: String) -> bool:
	for child in node.find_children("*", "Button", true, false):
		if child.text == title and child.is_visible_in_tree():
			return true
	return false

func run() -> void:
	var state: Node = root.get_node("State")
	var original_path: String = state.save_path
	var prefix := "prueba_archivo_" + str(OS.get_process_id())
	state.save_path = "user://" + prefix + ".json"
	check(state.new_game(), "Partida aislada creada")
	var original: Dictionary = state.data.duplicate(true)
	var app: Control = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	if is_instance_valid(app.opening):
		app.opening.hide()
	app.show_menu()
	check(button_exists(app.page, "Partidas"), "Menú ofrece administrar partidas")
	if app.has_method("show_save_panel"):
		app.show_save_panel()
		check(button_exists(app.overlay, "Exportar copia") and button_exists(app.overlay, "Importar copia"), "Panel ofrece ambas vías de recuperación")
	else:
		check(false, "Panel de partidas disponible")
	var copy_path := "user://" + prefix + "-exportada.json"
	if app.has_method("export_save_file"):
		check(app.export_save_file(copy_path), "Exportación nativa escribe archivo")
		check(FileAccess.get_file_as_string(copy_path) == state.export_save(), "Archivo exportado conserva estado completo")
		check(not app.export_save_file(copy_path), "Exportación no pisa una copia existente")
	else:
		check(false, "Exportación nativa disponible")
	var imported: Dictionary = original.duplicate(true)
	imported.flags["importada_en_ui"] = true
	if app.has_method("prepare_import") and app.has_method("confirm_import"):
		app.prepare_import("{ roto", "mala.json")
		check(state.data == original and not button_exists(app.overlay, "Sustituir partida"), "Archivo inválido no llega a confirmación")
		app.prepare_import(JSON.stringify(imported), "copia.json")
		check(state.data == original and button_exists(app.overlay, "Sustituir partida"), "Archivo válido espera confirmación sin cambiar progreso")
		app.close_modal()
		check(state.data == original, "Cancelar conserva la partida")
		app.prepare_import(JSON.stringify(imported), "copia.json")
		app.confirm_import()
		check(state.data.flags.get("importada_en_ui", false) and state.read_save(state.save_path).flags.get("importada_en_ui", false), "Confirmar importa y guarda")
		app.show_save_panel()
		check(button_exists(app.overlay, "Copias anteriores"), "La copia interna anterior puede recuperarse desde el juego")
		if app.has_method("show_previous_saves"):
			app.show_previous_saves()
			var chose_copy := false
			for button in app.overlay.find_children("*", "Button", true, false):
				if button.text.begins_with("Copia local ·"):
					button.pressed.emit()
					chose_copy = true
					break
			check(chose_copy and button_exists(app.overlay, "Sustituir partida"), "Copia interna también exige confirmación")
			app.confirm_import()
			check(not state.data.flags.get("importada_en_ui", false) and not state.read_save(state.save_path).flags.get("importada_en_ui", false), "Deshacer importación recupera partida anterior")
		else:
			check(false, "Listado de copias locales disponible")
	else:
		check(false, "Confirmación de importación disponible")
	if DisplayServer.get_name() != "headless":
		for size in [Vector2i(1280, 720), Vector2i(844, 390)]:
			root.size = size
			app.show_menu()
			app.show_save_panel()
			for frame in 5:
				await process_frame
			if size.x == 844:
				for label in app.overlay.find_children("*", "Label", true, false):
					if "decisiones" in label.text and "privado" in label.text:
						check(label.get_global_rect().end.y <= app.modal_body.get_parent().get_global_rect().end.y, "Aviso privado visible sin desplazamiento en móvil horizontal")
			RenderingServer.force_draw()
			check(root.get_texture().get_image().save_png(ProjectSettings.globalize_path("res://../docs/evidence/partidas_%dx%d.png" % [size.x, size.y])) == OK, "Captura de partidas " + str(size))
	app.queue_free()
	for filename in DirAccess.get_files_at("user://"):
		if filename.begins_with(prefix):
			DirAccess.remove_absolute("user://" + filename)
	state.save_path = original_path
	print("ARCHIVOS UI: %d comprobaciones, %d fallos" % [checks, failures.size()])
	quit(0 if failures.is_empty() else 1)
