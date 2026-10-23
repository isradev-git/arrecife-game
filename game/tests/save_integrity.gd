extends SceneTree

var failures: Array[String] = []
var count := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, label: String) -> void:
	count += 1
	if not ok:
		failures.append(label)
		push_error("FALLO: " + label)

func write_text(path: String, value: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	check(file != null, "Archivo de ensayo abierto: " + path.get_file())
	if file:
		file.store_string(value)
		file.close()

func run() -> void:
	var state: Node = root.get_node("State")
	var original_path: String = state.save_path
	var prefix := "prueba_integridad_" + str(OS.get_process_id())
	state.save_path = "user://" + prefix + ".json"
	check(state.new_game(), "Partida inicial creada")
	state.data.flags["prueba_previa"] = true
	check(state.save_game(), "Progreso anterior guardado")
	var previous: Dictionary = state.data.duplicate(true)
	var previous_file := FileAccess.get_file_as_string(state.save_path)
	var blocked_temp := ProjectSettings.globalize_path(state.save_path + ".tmp")
	check(DirAccess.make_dir_absolute(blocked_temp) == OK, "Bloqueo de escritura preparado")
	check(not state.new_game(), "Nueva partida informa fallo de escritura")
	check(state.data == previous, "Nueva partida fallida conserva memoria")
	check(FileAccess.get_file_as_string(state.save_path) == previous_file, "Nueva partida fallida conserva archivo anterior")
	check(state.load_game() and state.data.flags.get("prueba_previa", false), "Partida anterior sigue cargable")
	previous = state.data.duplicate(true)
	DirAccess.remove_absolute(blocked_temp)
	var exported: String = state.export_save()
	check(not exported.is_empty() and JSON.parse_string(exported) == state.data, "Exportación manual contiene partida completa")
	check(not state.import_save("{ roto") and state.data == previous, "Importación inválida conserva partida")
	check(not state.import_save(JSON.stringify({"version": 999})) and state.data == previous, "Importación futura conserva partida")
	check(DirAccess.make_dir_absolute(blocked_temp) == OK, "Fallo de importación preparado")
	check(not state.import_save(exported) and state.data == previous and FileAccess.get_file_as_string(state.save_path) == previous_file, "Importación sin escritura no declara éxito")
	DirAccess.remove_absolute(blocked_temp)
	var imported: Dictionary = previous.duplicate(true)
	imported.flags["importacion_comprobada"] = true
	check(state.import_save(JSON.stringify(imported)) and state.data.flags.get("importacion_comprobada", false), "Importación válida reemplaza sólo tras guardarse")
	var archived := false
	for filename in DirAccess.get_files_at("user://"):
		if filename.begins_with(prefix + ".json.previa-") and FileAccess.get_file_as_string("user://" + filename) == previous_file:
			archived = true
	check(archived, "Importación conserva copia de la partida anterior")
	check(state.import_save(exported) and state.data == previous, "Copia exportada restaura el progreso anterior")
	var before_document: Dictionary = state.data.duplicate(true)
	var app: Control = load("res://scenes/main.tscn").instantiate()
	root.add_child(app)
	app.show_document("registro")
	var primary = state.read_save(state.save_path)
	var backup = state.read_save(state.save_path + ".bak")
	check(primary != null and "registro" in primary.documents and primary.flags.get("lectura_copiada", false) and "lectura_agua" in primary.discoveries, "Documento y efectos guardados juntos")
	check(backup != null and backup.documents == before_document.documents and backup.flags == before_document.flags, "Copia anterior no contiene lectura parcial")
	var before_failed_document: Dictionary = state.data.duplicate(true)
	var before_failed_file := FileAccess.get_file_as_string(state.save_path)
	check(DirAccess.make_dir_absolute(blocked_temp) == OK, "Fallo de lectura documental preparado")
	app.show_document("orden_copia")
	check(state.data == before_failed_document and FileAccess.get_file_as_string(state.save_path) == before_failed_file, "Documento fallido no altera memoria ni disco")
	var claimed_saved := false
	for label in app.overlay.find_children("*", "Label", true, false):
		if "COPIA GUARDADA EN EL DECK" in label.text:
			claimed_saved = true
	check(not claimed_saved, "Documento fallido no anuncia copia guardada")
	DirAccess.remove_absolute(blocked_temp)
	check(state.apply({"offer": "retorno_agua"}), "Contrato ofrecido")
	var before_accept: Dictionary = state.data.duplicate(true)
	check(DirAccess.make_dir_absolute(blocked_temp) == OK, "Fallo al aceptar preparado")
	check(not state.accept("retorno_agua") and state.data == before_accept, "Aceptación fallida no avanza contrato")
	DirAccess.remove_absolute(blocked_temp)
	check(state.accept("retorno_agua"), "Contrato aceptado al reintentar")
	var before_travel: Dictionary = state.data.duplicate(true)
	check(DirAccess.make_dir_absolute(blocked_temp) == OK, "Fallo al viajar preparado")
	check(not state.navigate("ap_cocina") and state.data == before_travel, "Viaje fallido conserva ubicación")
	DirAccess.remove_absolute(blocked_temp)
	app.queue_free()
	var valid_file := FileAccess.get_file_as_string(state.save_path)
	var valid_state: Dictionary = state.data.duplicate(true)
	write_text(state.save_path, "{ primario roto")
	check(state.load_game() and state.data.missions.retorno_agua == "AVAILABLE" and not state.last_error.is_empty(), "Primario corrupto recupera backup")
	write_text(state.save_path, '{"version":1,"missions":{}}')
	check(state.load_game() and state.data.missions.retorno_agua == "AVAILABLE", "Primario JSON incompleto recupera backup")
	write_text(state.save_path, valid_file)
	write_text(state.save_path + ".bak", "{ backup roto")
	check(state.load_game() and state.data.missions.retorno_agua == "ACTIVE", "Backup corrupto no invalida primario sano")
	DirAccess.remove_absolute(state.save_path)
	DirAccess.remove_absolute(state.save_path + ".bak")
	check(not state.load_game() and not state.has_save(), "Sin archivos no inventa una partida")
	write_text(state.save_path + ".tmp", valid_file)
	check(state.has_save() and state.load_game() and state.data.missions.retorno_agua == "ACTIVE", "Interrupción tras escribir temporal recupera partida")
	check(DirAccess.make_dir_absolute(ProjectSettings.globalize_path(state.save_path)) == OK, "Fallo tras recuperación temporal preparado")
	check(not state.apply({"flag": "tras_temporal"}) and state.read_save(state.save_path + ".bak") == valid_state, "Escritura fallida conserva única copia temporal recuperada")
	DirAccess.remove_absolute(state.save_path)
	DirAccess.remove_absolute(state.save_path + ".bak")
	write_text(state.save_path + ".tmp", valid_file)
	check(state.new_game() and state.read_save(state.save_path + ".bak") == valid_state, "Nueva partida desde temporal conserva copia recuperada")
	DirAccess.remove_absolute(state.save_path)
	DirAccess.remove_absolute(state.save_path + ".bak")
	write_text(state.save_path + ".tmp", valid_file)
	check(state.import_save(JSON.stringify(imported)) and state.read_save(state.save_path + ".bak") == valid_state, "Importación desde único temporal conserva copia recuperada")
	DirAccess.remove_absolute(state.save_path)
	DirAccess.remove_absolute(state.save_path + ".bak")
	DirAccess.remove_absolute(state.save_path + ".tmp")
	var future: Dictionary = valid_state.duplicate(true)
	future.version = 999
	var future_file := JSON.stringify(future)
	write_text(state.save_path, future_file)
	check(not state.load_game() and FileAccess.get_file_as_string(state.save_path) == future_file, "Versión futura se rechaza sin borrarse")
	write_text(state.save_path + ".bak", valid_file)
	check(not state.load_game(), "Backup antiguo no permite continuar sobre un primario futuro")
	DirAccess.remove_absolute(state.save_path + ".bak")
	state.data = valid_state
	check(not state.save_game() and FileAccess.get_file_as_string(state.save_path) == future_file, "Cliente antiguo no sobrescribe archivo futuro")
	check(not state.new_game() and FileAccess.get_file_as_string(state.save_path) == future_file and state.data == valid_state, "Nueva partida no sustituye versión futura")
	DirAccess.remove_absolute(state.save_path)
	write_text(state.save_path + ".tmp", future_file)
	check(not state.new_game() and not state.save_game() and not state.load_game() and FileAccess.get_file_as_string(state.save_path + ".tmp") == future_file, "Temporal futuro tampoco puede ser sobrescrito por cliente antiguo")
	DirAccess.remove_absolute(state.save_path + ".tmp")
	var unknown_mission: Dictionary = valid_state.duplicate(true)
	unknown_mission.missions["contrato_de_otra_version"] = "ACTIVE"
	check(not state.valid(unknown_mission), "Misión desconocida se rechaza sin descartarla")
	check(state.has_method("migrate_save"), "Migración v1 expuesta para probarse")
	if state.has_method("migrate_save"):
		var old: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/partida_h1_v1.json"))
		var migrated: Dictionary = state.migrate_save(old)
		check(migrated.version == 1 and migrated.missions.retorno_agua == "ACTIVE" and migrated.missions.orden_duplicada == "LOCKED" and migrated.missions.prueba_presion == "LOCKED", "Migración de contenido v1 conserva contrato y añade pendientes")
		check(migrated.screen == old.screen and migrated.flags == old.flags and migrated.documents == old.documents and migrated.choices == old.choices, "Migración conserva ubicación, permisos y decisiones")
		check(state.migrate_save(migrated) == migrated, "Migración v1 es repetible sin cambios nuevos")
		DirAccess.remove_absolute(state.save_path)
		write_text(state.save_path, JSON.stringify(old))
		check(state.load_game() and state.data == migrated, "Fixture v1 anterior a nuevas misiones carga con migración")
	write_text(state.save_path, valid_file)
	write_text(state.save_path + ".bak", "{ backup roto")
	check(state.load_game() and state.data == valid_state, "Primario íntegro prevalece sobre backup dañado")
	write_text(state.save_path + ".tmp", "x".repeat(1048577))
	check(state.has_save() and state.load_game() and state.save_game(), "Temporal enorme dañado no bloquea primario íntegro")
	DirAccess.remove_absolute(state.save_path + ".tmp")
	DirAccess.remove_absolute(state.save_path + ".bak")
	check(DirAccess.make_dir_absolute(ProjectSettings.globalize_path(state.save_path + ".bak")) == OK, "Fallo de renombrado preparado")
	var before_rename := FileAccess.get_file_as_string(state.save_path)
	check(not state.apply({"flag": "fallo_renombrado"}) and state.data == valid_state and FileAccess.get_file_as_string(state.save_path) == before_rename, "Renombrado fallido conserva el último archivo válido")
	DirAccess.remove_absolute(state.save_path + ".bak")
	write_text(state.save_path + ".bak", valid_file)
	DirAccess.remove_absolute(state.save_path)
	check(DirAccess.make_dir_absolute(ProjectSettings.globalize_path(state.save_path)) == OK, "Fallo de promoción preparado")
	check(not state.apply({"flag": "promocion_fallida"}) and state.data == valid_state and FileAccess.get_file_as_string(state.save_path + ".bak") == valid_file, "Promoción fallida mantiene backup íntegro")
	DirAccess.remove_absolute(state.save_path)
	write_text(state.save_path, valid_file)
	write_text(state.save_path + ".bak", future_file)
	check(not state.save_game() and FileAccess.get_file_as_string(state.save_path + ".bak") == future_file, "Backup de versión futura no se sobrescribe")
	write_text(state.save_path + ".bak", "{ backup roto")
	write_text(state.save_path, "{ primario roto")
	DirAccess.remove_absolute(state.save_path + ".tmp")
	check(not state.load_game() and not state.has_save(), "Dos copias corruptas se conservan sin inventar progreso")
	for filename in DirAccess.get_files_at("user://"):
		if filename.begins_with(prefix):
			DirAccess.remove_absolute("user://" + filename)
	state.save_path = original_path
	print("GUARDADO: %d comprobaciones, %d fallos" % [count, failures.size()])
	quit(0 if failures.is_empty() else 1)
