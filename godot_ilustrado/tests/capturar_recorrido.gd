extends SceneTree

var escena: Node3D
var fotograma := 0
var video := "--video" in OS.get_cmdline_user_args()
const CARPETA = "res://../trabajo/arte/revisiones/sota_prendas_3d_v5/"
func _initialize() -> void: call_deferred("preparar")
func preparar() -> void:
	escena = load("res://recorrido_3d.tscn").instantiate()
	root.add_child(escena)
	escena.set_physics_process(false)

func _process(_delta: float) -> bool:
	if not is_instance_valid(escena): return false
	fotograma += 1
	if not video and fotograma in [1, 181, 361]:
		escena.jugadora.position.x = [0.0, 13.0, 28.0][int((fotograma - 1) / 180)]
		escena.camara.position.x = escena.jugadora.position.x
		escena.jugadora.destino = escena.jugadora.position.x + (3 if fotograma < 361 else -3)
	if video:
		if fotograma == 1: escena.jugadora.destino = 20
		if fotograma == 241: escena.jugadora.destino = -3
		if fotograma == 481: escena.jugadora.destino = INF
	escena.pausa = false
	escena._physics_process(1.0 / 60)
	if not video and fotograma in [120, 300, 480]: guardar.call_deferred(fotograma)
	if fotograma >= 540:
		escena.free()
		quit()
	return false

func guardar(numero: int) -> void:
	await RenderingServer.frame_post_draw
	print("Captura ", numero, ": ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), " llamadas de dibujo")
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(CARPETA + "tramo_%03d.png" % numero))
