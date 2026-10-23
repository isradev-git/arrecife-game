extends Node

signal changed
signal save_failed(message: String)
const VERSION := 1
const STATUSES := ["LOCKED", "AVAILABLE", "ACTIVE", "READY_TO_COMPLETE", "COMPLETED"]
var data: Dictionary = {}
var save_path := "user://partida.json"
var last_error := ""
var settings := {"master": 0.8, "music": 0.65, "effects": 0.7, "hints": true, "reduced_motion": false, "large_text": false}

func _ready() -> void:
	var config := ConfigFile.new()
	if config.load("user://opciones.cfg") == OK:
		for key in settings:
			var value = config.get_value("opciones", key, settings[key])
			if typeof(value) == typeof(settings[key]):
				settings[key] = value
	for bus_name in ["Music", "Effects"]:
		if AudioServer.get_bus_index(bus_name) < 0:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.bus_count - 1, bus_name)
	apply_audio()

func new_game() -> bool:
	if incompatible_local():
		last_error = "Existe una partida incompatible. Se conserva y esta versión no la sustituirá."
		return false
	if not archive_current():
		return false
	var previous_data := data
	data = {"version": VERSION, "screen": Content.world.start, "zone": "apartamento", "missions": {}, "flags": {"acreditacion_residencia": true}, "discoveries": [], "documents": [], "messages": [], "unlocked": ["apartamento"], "choices": {}}
	for id in Content.missions:
		data.missions[id] = "LOCKED"
	if persist():
		return true
	data = previous_data
	return false

func matches(condition: Dictionary) -> bool:
	if data.is_empty():
		return condition.is_empty()
	if condition.has("flag") and not data.flags.get(condition.flag, false):
		return false
	if condition.has("not_flag") and data.flags.get(condition.not_flag, false):
		return false
	if condition.has("mission") and data.missions.get(condition.mission, "LOCKED") not in condition.states:
		return false
	return true

func unread_messages() -> Array[String]:
	var result: Array[String] = []
	if data.is_empty():
		return result
	for id in Content.story.messages:
		if matches(Content.story.messages[id].get("visible_if", {})) and id not in data.messages:
			result.append(id)
	return result

func reply_to_message(id: String, reply_id: String) -> bool:
	if not Content.story.messages.has(id) or id not in data.messages or data.choices.has("message:" + id):
		return false
	var message: Dictionary = Content.story.messages[id]
	if not matches(message.get("visible_if", {})):
		return false
	for reply in message.get("replies", []):
		if reply.id == reply_id:
			return apply(reply.get("effects", {}), "message:" + id, reply_id)
	return false

func apply(effects: Dictionary, choice_key: String = "", choice_value: String = "") -> bool:
	var previous := data.duplicate(true)
	if not choice_key.is_empty():
		data.choices[choice_key] = choice_value
	if effects.has("offer") and data.missions[effects.offer] == "LOCKED":
		data.missions[effects.offer] = "AVAILABLE"
	if effects.has("flag"):
		data.flags[effects.flag] = true
	for flag in effects.get("flags", []):
		data.flags[flag] = true
	for key in ["discover", "document", "message"]:
		var list_key: String = {"discover":"discoveries", "document":"documents", "message":"messages"}[key]
		if effects.has(key) and effects[key] not in data[list_key]:
			data[list_key].append(effects[key])
	for zone in effects.get("unlock", []):
		if zone not in data.unlocked:
			data.unlocked.append(zone)
	refresh_missions()
	if data == previous:
		return true
	if persist():
		return true
	data = previous
	return false

func accept(id: String) -> bool:
	if data.missions.get(id) != "AVAILABLE":
		return false
	var previous := data.duplicate(true)
	data.missions[id] = "ACTIVE"
	for zone in Content.missions[id].get("unlocks_on_accept", []):
		if zone not in data.unlocked:
			data.unlocked.append(zone)
	refresh_missions()
	if persist():
		return true
	data = previous
	return false

func refresh_missions() -> void:
	for id in Content.missions:
		if data.missions.get(id) not in ["ACTIVE", "READY_TO_COMPLETE"]:
			continue
		var complete := true
		for step in Content.missions[id].steps:
			complete = complete and data.flags.get(step.flag, false)
		if complete:
			data.missions[id] = "COMPLETED" if data.flags.get(Content.missions[id].completion_flag, false) else "READY_TO_COMPLETE"

func travel_reason(target: String) -> String:
	if not Content.world.screens.has(target):
		return "Destino desconocido."
	var destination: Dictionary = Content.world.screens[target]
	if destination.zone != data.zone:
		var authorized := false
		for route in Content.world.routes:
			if route.from == data.zone and route.to == destination.zone and matches(route.requires):
				authorized = true
		if not authorized:
			return "No tienes una ruta autorizada hasta ese destino. Revisa el contrato y tus acreditaciones."
	if not destination.implemented:
		return "Este destino aún no está disponible."
	return ""

func navigate(target: String) -> bool:
	if not travel_reason(target).is_empty():
		return false
	var previous := data.duplicate(true)
	data.screen = target
	data.zone = Content.world.screens[target].zone
	if persist():
		return true
	data = previous
	return false

func valid(value: Variant) -> bool:
	if not value is Dictionary or value.get("version") != VERSION:
		return false
	for key in ["missions", "flags", "choices"]:
		if not value.get(key) is Dictionary:
			return false
	for key in ["discoveries", "documents", "messages", "unlocked"]:
		if not value.get(key) is Array:
			return false
		for item in value[key]:
			if not item is String:
				return false
	if not value.get("screen") is String or not Content.world.screens.has(value.screen):
		return false
	if not Content.world.screens[value.screen].implemented or value.get("zone") != Content.world.screens[value.screen].zone:
		return false
	if value.missions.get("retorno_agua") not in STATUSES:
		return false
	for id in value.missions:
		if not id is String or not Content.missions.has(id) or value.missions[id] not in STATUSES:
			return false
	for flag in value.flags:
		if not flag is String or not value.flags[flag] is bool:
			return false
	for key in value.choices:
		if not key is String or not value.choices[key] is String:
			return false
	for pair in [["documents",Content.story.documents],["messages",Content.story.messages],["discoveries",Content.story.records],["unlocked",Content.world.zones]]:
		for id in value[pair[0]]:
			if not pair[1].has(id):
				return false
	return true

func read_save(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() > 1048576:
		return null
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return null
	return parser.data if valid(parser.data) else null

func incompatible_save(path: String, unreadable_is_incompatible: bool = true) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() > 1048576:
		return unreadable_is_incompatible
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return false
	var parsed = parser.data
	if not parsed is Dictionary or not parsed.has("version"):
		return false
	if parsed.version != VERSION:
		return true
	if parsed.get("screen") is String and not Content.world.screens.has(parsed.screen):
		return true
	if parsed.get("missions") is Dictionary:
		for id in parsed.missions:
			if not Content.missions.has(id):
				return true
	for pair in [["documents",Content.story.documents],["messages",Content.story.messages],["discoveries",Content.story.records],["unlocked",Content.world.zones]]:
		if parsed.get(pair[0]) is Array:
			for id in parsed[pair[0]]:
				if not pair[1].has(id):
					return true
	return false

func incompatible_local() -> bool:
	for path in [save_path, save_path + ".bak"]:
		if incompatible_save(path):
			return true
	return incompatible_save(save_path + ".tmp", read_save(save_path) == null and read_save(save_path + ".bak") == null)

func has_save() -> bool:
	if incompatible_local():
		return false
	return read_save(save_path) != null or read_save(save_path + ".bak") != null or read_save(save_path + ".tmp") != null

func migrate_save(value: Dictionary) -> Dictionary:
	if value.get("version") == VERSION:
		var migrated := value.duplicate(true)
		for id in Content.missions:
			if not migrated.missions.has(id):
				migrated.missions[id] = "LOCKED"
		return migrated
	return {}

func archive_current() -> bool:
	for previous in [save_path, save_path + ".bak", save_path + ".tmp"]:
		if read_save(previous) != null:
			if DirAccess.copy_absolute(previous, save_path + ".previa-" + str(Time.get_ticks_usec())) != OK:
				last_error = "No se pudo respaldar la partida anterior. No se ha sustituido."
				return false
			break
	return true

func export_save() -> String:
	if incompatible_local():
		last_error = "La partida pertenece a otra versión y no se puede exportar desde este cliente."
		return ""
	for path in [save_path, save_path + ".bak", save_path + ".tmp"]:
		var saved = read_save(path)
		if saved != null:
			return JSON.stringify(saved)
	last_error = "No hay una partida íntegra que exportar."
	return ""

func import_save(contents: String) -> bool:
	if contents.to_utf8_buffer().size() > 1048576:
		last_error = "El archivo importado supera el límite permitido."
		return false
	var parser := JSON.new()
	if parser.parse(contents) != OK:
		last_error = "El archivo importado no contiene JSON válido."
		return false
	var parsed = parser.data
	if not valid(parsed):
		last_error = "El archivo importado no es una partida compatible."
		return false
	if incompatible_local():
		last_error = "Existe una partida local incompatible que se conserva."
		return false
	if not archive_current():
		return false
	var previous := data
	data = migrate_save(parsed)
	if persist():
		return true
	data = previous
	return false

func load_game() -> bool:
	last_error = ""
	if incompatible_local():
		last_error = "La partida pertenece a otra versión. Actualiza el juego; sus archivos se conservan."
		return false
	var value = read_save(save_path)
	if value == null:
		value = read_save(save_path + ".bak")
		if value != null:
			last_error = "Se ha recuperado la copia anterior de la partida."
	if value == null:
		value = read_save(save_path + ".tmp")
		if value != null:
			last_error = "Se ha recuperado una escritura interrumpida de la partida."
	if value == null:
		last_error = "No se ha encontrado una partida compatible. Los archivos existentes se conservan."
		return false
	var migrated := migrate_save(value)
	if migrated.is_empty():
		last_error = "La partida requiere una versión más reciente del juego."
		return false
	data = migrated
	refresh_missions()
	changed.emit()
	return true

func persist() -> bool:
	if not save_game():
		save_failed.emit(last_error)
		return false
	changed.emit()
	return true

func save_game() -> bool:
	if not valid(data):
		last_error = "El estado no es válido; se conserva el guardado anterior."
		return false
	if incompatible_local():
		last_error = "Hay una partida incompatible. Esta versión no la sobrescribirá."
		return false
	var temp := save_path + ".tmp"
	if read_save(save_path) == null and read_save(save_path + ".bak") == null and read_save(temp) != null:
		if DirAccess.copy_absolute(temp, save_path + ".bak") != OK:
			last_error = "No se pudo conservar la única copia recuperable."
			return false
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		last_error = "No se pudo guardar. Comprueba el espacio y los permisos del dispositivo."
		return false
	var written := file.store_string(JSON.stringify(data))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if not written or write_error != OK:
		last_error = "No se pudo completar la escritura; la partida anterior se conserva."
		return false
	if read_save(temp) == null:
		last_error = "No se pudo verificar el guardado."
		return false
	# Una partida dañada o de versión futura queda recuperable al iniciar otra.
	if FileAccess.file_exists(save_path):
		var suffix := ".bak" if read_save(save_path) != null else ".incompatible-" + str(Time.get_unix_time_from_system())
		if DirAccess.rename_absolute(save_path, save_path + suffix) != OK:
			last_error = "No se pudo conservar la partida anterior."
			return false
	if DirAccess.rename_absolute(temp, save_path) != OK:
		last_error = "No se pudo terminar el guardado; la copia anterior sigue disponible."
		return false
	last_error = ""
	return true

func set_option(key: String, value: Variant) -> void:
	settings[key] = value
	var config := ConfigFile.new()
	for option in settings:
		config.set_value("opciones", option, settings[option])
	if config.save("user://opciones.cfg") != OK:
		save_failed.emit("No se han podido guardar las opciones.")
	apply_audio()

func apply_audio() -> void:
	for pair in [["Master","master"],["Music","music"],["Effects","effects"]]:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(pair[0]), linear_to_db(clampf(settings[pair[1]], 0.0, 1.0)))
