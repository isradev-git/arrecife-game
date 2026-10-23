extends SceneTree

class MockCloud:
	extends RefCounted
	var online := true
	var slots := {}
	func read(user_id: String) -> Dictionary:
		if not online:
			return {"error": "offline"}
		return {"ok": true, "record": slots.get(user_id, {}).duplicate(true)}
	func write(user_id: String, snapshot: Dictionary, expected_revision: int) -> Dictionary:
		if not online:
			return {"error": "offline"}
		var current: Dictionary = slots.get(user_id, {})
		if current.get("revision", 0) != expected_revision:
			return {"error": "conflict", "record": current.duplicate(true)}
		var record := {"revision": expected_revision + 1, "snapshot": snapshot.duplicate(true)}
		slots[user_id] = record
		return {"ok": true, "record": record.duplicate(true)}

var failures: Array[String] = []
var count := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, label: String) -> void:
	count += 1
	if not ok:
		failures.append(label)
		push_error("FALLO: " + label)

func run() -> void:
	var base: Dictionary = root.get_node("State").migrate_save(JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/partida_h1_v1.json")))
	var cloud := MockCloud.new()
	var sync = load("res://scripts/core/save_sync.gd").new()
	check(sync.queue_local(base) and sync.status == "local", "Invitado sólo tiene guardado local")
	cloud.online = false
	sync.set_authenticated_identity("alice", cloud)
	check(not sync.synchronize() and sync.status == "pending" and cloud.slots.is_empty(), "Sin conexión mantiene pendiente local")
	cloud.online = true
	check(sync.synchronize() and sync.status == "cloud" and cloud.slots.alice.revision == 1, "Subida confirmada con revisión")
	var stale = load("res://scripts/core/save_sync.gd").new()
	stale.queue_local(base)
	stale.set_authenticated_identity("alice", cloud)
	var remote_newer := base.duplicate(true)
	remote_newer.flags["remoto"] = true
	cloud.write("alice", remote_newer, 1)
	check(not stale.synchronize() and stale.status == "conflict" and cloud.slots.alice.snapshot == remote_newer, "Vincular invitado no pisa partida remota")
	var local_newer := base.duplicate(true)
	local_newer.flags["local"] = true
	sync.queue_local(local_newer)
	check(not sync.synchronize() and sync.status == "conflict" and sync.pending.flags.get("local", false), "Escritor obsoleto conserva cambios locales")
	check(not sync.set_authenticated_identity("charlie", cloud) and sync.user_id == "alice" and not cloud.slots.has("charlie"), "Pendiente de una cuenta impide cambiar identidad")
	var other = load("res://scripts/core/save_sync.gd").new()
	other.queue_local(base)
	other.set_authenticated_identity("bob", cloud)
	check(other.synchronize() and cloud.slots.bob.revision == 1 and cloud.slots.alice.snapshot == remote_newer, "Mock separa dos identificadores")
	print("SINCRONIZACIÓN SIMULADA: %d comprobaciones, %d fallos" % [count, failures.size()])
	quit(0 if failures.is_empty() else 1)
