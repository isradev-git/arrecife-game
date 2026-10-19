extends SceneTree
var escena: Node3D
var paso := 0
var inicio := 0
var fase := 0
var nombres := ["Completo", "Sin sombras", "Sin vapor", "Sin sonda", "Materiales simples", "Sin personajes"]
func _initialize() -> void: call_deferred("preparar")
func preparar() -> void:
	escena = load("res://demo_velvet.tscn").instantiate()
	root.add_child(escena)
	escena.jugadora.position.x = 20
	escena.camara.position.x = 20
	escena.set_physics_process(false)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
func _process(_delta: float) -> bool:
	if not is_instance_valid(escena): return false
	paso += 1
	if paso == 30: inicio = Time.get_ticks_msec()
	if paso == 90:
		print(nombres[fase], ": ", (Time.get_ticks_msec()-inicio)/60.0, " ms/fotograma; CPU ", Performance.get_monitor(Performance.TIME_PROCESS)*1000, "; llamadas ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
		fase += 1
		paso = 0
		if fase == 1:
			for luz in escena.find_children("*","Light3D",true,false): luz.shadow_enabled = false
		if fase == 2:
			for nube in escena.get_child(0).humo: nube.visible = false
		if fase == 3:
			for sonda in escena.find_children("*","ReflectionProbe",true,false): sonda.queue_free()
		if fase == 4:
			var m := StandardMaterial3D.new()
			m.albedo_color = Color(.2,.3,.4)
			for o in escena.get_child(0).get_children():
				if o is GeometryInstance3D: o.material_override = m
		if fase == 5:
			escena.jugadora.hide()
			for persona in escena.get_child(0).figurantes:persona.hide()
			for vecino in escena.get_child(0).paseantes:vecino.cuerpo.hide()
		if fase == 6:quit()
	return false
