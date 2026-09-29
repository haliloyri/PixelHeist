extends RefCounted
## Checksummed Variant data (objects disabled). Rename is the commit point.
const MAGIC = "PHSTATE1\n"
const MAX_BYTES = 16 * 1024 * 1024
var interruption_hook: Callable
var backup_error: Error = OK

func _digest(bytes: PackedByteArray) -> String:
	var hash := HashingContext.new()
	hash.start(HashingContext.HASH_SHA256)
	hash.update(bytes)
	return hash.finish().hex_encode()

func read_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path): return {"status": "missing"}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null: return {"status": "unreadable"}
	var length := file.get_length()
	if length < MAGIC.length() + 65 or length > MAX_BYTES: return {"status": "corrupt"}
	var raw := file.get_buffer(length)
	file.close()
	var header_size := MAGIC.length() + 65
	if raw.slice(0, MAGIC.length()).get_string_from_ascii() != MAGIC: return {"status": "corrupt"}
	if raw[header_size - 1] != 10: return {"status": "corrupt"}
	var expected := raw.slice(MAGIC.length(), header_size - 1).get_string_from_ascii()
	var payload := raw.slice(header_size)
	if _digest(payload) != expected: return {"status": "corrupt"}
	var value = bytes_to_var(payload)
	if not value is Dictionary: return {"status": "corrupt"}
	return {"status": "ok", "data": value}

func _write_file(path: String, value: Dictionary) -> Error:
	var payload := var_to_bytes(value)
	if payload.size() > MAX_BYTES - 128: return ERR_OUT_OF_MEMORY
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null: return FileAccess.get_open_error()
	file.store_buffer((MAGIC + _digest(payload) + "\n").to_utf8_buffer())
	file.store_buffer(payload)
	file.flush()
	var error := file.get_error()
	file.close()
	if error != OK: return error
	return OK if read_file(path).get("status") == "ok" else ERR_FILE_CORRUPT

func write(path: String, value: Dictionary) -> Error:
	backup_error = OK
	var error := _write_file(path + ".tmp", value)
	if error != OK: return error
	_checkpoint("after_flush")
	error = DirAccess.rename_absolute(path + ".tmp", path)
	if error != OK: return error
	_checkpoint("after_replace")
	# Mirror the committed generation, so ordinary single-file corruption need not roll back grants.
	backup_error = _write_file(path + ".bak.tmp", value)
	if backup_error == OK:
		backup_error = DirAccess.rename_absolute(path + ".bak.tmp", path + ".bak")
	_checkpoint("after_backup")
	return OK

func _checkpoint(stage: String) -> void:
	if interruption_hook.is_valid(): interruption_hook.call(stage)
