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
	var previous := save_path if FileAccess.file_exists(save_path) else save_path + ".bak"
	if FileAccess.file_exists(previous):
		if DirAccess.copy_absolute(previous, save_path + ".previa-" + str(Time.get_unix_time_from_system())) != OK:
			last_error = "No se pudo respaldar la partida anterior. No se ha reiniciado."
			return false
	data = {"version": VERSION, "screen": Content.world.start, "zone": "apartamento", "missions": {}, "flags": {"acreditacion_residencia": true}, "discoveries": [], "documents": [], "messages": [], "unlocked": ["apartamento"], "choices": {}}
	for id in Content.missions:
		data.missions[id] = "LOCKED"
	persist()
	return true

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

func apply(effects: Dictionary) -> void:
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
	persist()

func accept(id: String) -> bool:
	if data.missions.get(id) != "AVAILABLE":
		return false
	data.missions[id] = "ACTIVE"
	for zone in Content.missions[id].get("unlocks_on_accept", []):
		if zone not in data.unlocked:
			data.unlocked.append(zone)
	refresh_missions()
	persist()
	return true

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
		return "Este trayecto continúa en el próximo hito. Tu progreso ya está guardado; puedes seguir explorando el apartamento y La Fiebre."
	return ""

func navigate(target: String) -> bool:
	if not travel_reason(target).is_empty():
		return false
	data.screen = target
	data.zone = Content.world.screens[target].zone
	persist()
	return true

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
	for id in Content.missions:
		if value.missions.get(id) not in STATUSES:
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

func has_save() -> bool:
	return read_save(save_path) != null or read_save(save_path + ".bak") != null

func load_game() -> bool:
	last_error = ""
	var value = read_save(save_path)
	if value == null:
		value = read_save(save_path + ".bak")
		if value != null:
			last_error = "Se ha recuperado la copia anterior de la partida."
	if value == null:
		last_error = "No se ha encontrado una partida compatible. Los archivos existentes se conservan."
		return false
	data = value
	changed.emit()
	return true

func persist() -> void:
	changed.emit()
	if not save_game():
		save_failed.emit(last_error)

func save_game() -> bool:
	if not valid(data):
		last_error = "El estado no es válido; se conserva el guardado anterior."
		return false
	var temp := save_path + ".tmp"
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		last_error = "No se pudo guardar. Comprueba el espacio y los permisos del dispositivo."
		return false
	file.store_string(JSON.stringify(data))
	file.flush()
	file.close()
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
