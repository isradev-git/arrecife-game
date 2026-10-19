extends SceneTree
var escena: Node3D
var paso := 0
const CARPETA = "res://../trabajo/arte/revisiones/demo_velvet_3d_v1/"
func _initialize() -> void: call_deferred("preparar")
func preparar() -> void:
	escena = load("res://sota_360.tscn").instantiate()
	root.add_child(escena)
	escena.rotacion_automatica = false
	escena.distancia = 3.2
	escena.altura = 0.95
func _process(_delta: float) -> bool:
	if not is_instance_valid(escena): return false
	paso += 1
	if paso < 160 and paso % 20 == 1:
		escena.angulo = (paso / 20 as int) * TAU / 8
		escena.actualizar_camara()
	if paso < 160 and paso % 20 == 10: guardar.call_deferred()
	if paso == 161:
		escena.altura = 1.3
		escena.distancia = 1.65
		escena.angulo = PI/4
	if paso == 201:
		escena.altura = 1.59
		escena.distancia = .88
	if paso == 241:
		escena.altura = 1.25
		escena.distancia = 1.6
		escena.angulo = PI*1.05
	if paso in [180,220,260]: guardar.call_deferred()
	if paso > 270: quit()
	return false
func guardar() -> void:
	await RenderingServer.frame_post_draw
	var version := "v6" if "--anterior" in OS.get_cmdline_user_args() else "v7"
	var nombre := "%03d" % ((paso / 20 as int) * 45)
	if paso == 180: nombre = "ropa"
	if paso == 220: nombre = "cabeza"
	if paso == 260: nombre = "espalda"
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(CARPETA + version + "_" + nombre + ".png"))
