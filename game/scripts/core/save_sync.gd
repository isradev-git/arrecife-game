extends RefCounted

# Modelo local de sincronización. El repositorio real debe autenticar y autorizar cada petición.
var repository: RefCounted
var user_id := ""
var revision := 0
var pending: Dictionary = {}
var status := "local"

func queue_local(snapshot: Dictionary) -> bool:
	if not State.valid(snapshot):
		return false
	pending = State.migrate_save(snapshot)
	status = "pending" if not user_id.is_empty() else "local"
	return true

func set_authenticated_identity(verified_user_id: String, cloud_repository: RefCounted) -> bool:
	if verified_user_id.is_empty() or cloud_repository == null:
		return false
	if not user_id.is_empty() and user_id != verified_user_id:
		return false
	if user_id == verified_user_id:
		repository = cloud_repository
		return true
	user_id = verified_user_id
	repository = cloud_repository
	revision = 0
	status = "pending" if not pending.is_empty() else "local"
	return true

func synchronize() -> bool:
	if user_id.is_empty() or repository == null or pending.is_empty():
		return false
	var read_result: Dictionary = repository.read(user_id)
	if not read_result.get("ok", false):
		status = "pending" if read_result.get("error") == "offline" else "failed"
		return false
	var record: Dictionary = read_result.get("record", {})
	if not record.is_empty():
		if not record.get("snapshot") is Dictionary or not State.valid(record.snapshot) or not record.get("revision") is int:
			status = "failed"
			return false
		if revision == 0 and record.snapshot == pending:
			revision = record.revision
			pending.clear()
			status = "cloud"
			return true
		if record.revision != revision:
			status = "conflict"
			return false
	elif revision != 0:
		status = "conflict"
		return false
	var write_result: Dictionary = repository.write(user_id, pending, revision)
	if not write_result.get("ok", false):
		status = "conflict" if write_result.get("error") == "conflict" else ("pending" if write_result.get("error") == "offline" else "failed")
		return false
	var confirmed: Dictionary = write_result.get("record", {})
	if confirmed.get("snapshot") != pending or confirmed.get("revision") != revision + 1:
		status = "failed"
		return false
	revision = confirmed.revision
	pending.clear()
	status = "cloud"
	return true
