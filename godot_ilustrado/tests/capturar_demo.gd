extends SceneTree
var escena: Node3D
var paso := 0
var inicio := 0
const CARPETA = "res://../trabajo/arte/revisiones/demo_velvet_3d_v1/"
func _initialize() -> void: call_deferred("preparar")
func preparar() -> void:
	escena = load("res://demo_velvet.tscn").instantiate()
	root.add_child(escena)
	escena.set_physics_process(false)
	inicio = Time.get_ticks_msec()
func _process(_delta: float) -> bool:
	if not is_instance_valid(escena): return false
	paso += 1
	if paso < 370:
		escena.pausa = false
		escena.boton_pausa.text = "Pausa"
	if paso == 1:
		escena.jugadora.position.x = 9
		escena.camara.position.x = 9
	if paso == 121:
		escena.jugadora.position.x = 20
		escena.camara.position.x = 20
	if paso == 241:
		escena.jugadora.position.x = 31
		escena.camara.position.x = 31
	escena.jugadora.cuerpo.avanzar(1.0/60, paso < 370)
	if paso in [120,240,360]: guardar.call_deferred("velvet_%03d" % paso)
	if paso == 381:
		escena.jugadora.position.x = 16.4
		escena.camara.position.x = 20
		escena._process(0)
		escena.abrir_lectura()
	if paso == 410: guardar.call_deferred("dialogo_jefa")
	if paso == 421: escena.avanzar_linea()
	if paso == 450: guardar.call_deferred("dialogo_sota")
	if paso == 461:
		escena.cerrar_lectura()
		escena.jugadora.position.x = 9
		escena.camara.position.x = 9
		escena._process(0)
		escena.abrir_lectura()
	if paso == 490: guardar.call_deferred("monologo")
	if paso>500:
		print("Captura de 500 fotogramas: ", (Time.get_ticks_msec()-inicio)/1000.0," s reales; no benchmark en otros equipos")
		quit()
	return false
func guardar(nombre: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(CARPETA+nombre+".png"))
	print(nombre, ": llamadas ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
