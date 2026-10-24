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
	print("AMBIENTE: %d comprobaciones, %d fallos" % [checks, failures.size()])
	quit(0 if failures.is_empty() else 1)
