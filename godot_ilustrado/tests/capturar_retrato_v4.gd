extends SceneTree

var cuerpo: Node3D
var camara: Camera3D
var fotograma := 0
var anterior := "--anterior" in OS.get_cmdline_user_args()
const CARPETA = "res://../trabajo/arte/revisiones/sota_retrato_3d_v4/"
func _initialize() -> void: call_deferred("preparar")
func preparar() -> void:
	var mundo := Node3D.new()
	root.add_child(mundo)
	var entorno := WorldEnvironment.new()
	entorno.environment = Environment.new()
	entorno.environment.background_mode = Environment.BG_COLOR
	entorno.environment.background_color = Color("17232b")
	entorno.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	entorno.environment.ambient_light_energy = 0.5
	mundo.add_child(entorno)
	var luz := DirectionalLight3D.new()
	luz.rotation_degrees = Vector3(-30, -25, 0)
	luz.light_energy = 1.0
	mundo.add_child(luz)
	cuerpo = preload("res://cuerpo.gd").new()
	cuerpo.estudio_sota = true
	cuerpo.modelo_sota = preload("res://assets/sota_3d_v4/sota.glb")
	if anterior: cuerpo.modelo_sota = preload("res://assets/sota_3d_v3/sota.glb")
	mundo.add_child(cuerpo)
	camara = Camera3D.new()
	camara.projection = Camera3D.PROJECTION_ORTHOGONAL
	camara.size = 2.1
	camara.position = Vector3(0, 1, 7)
	mundo.add_child(camara)
	camara.look_at(Vector3(0, 1, 0))
	cuerpo.mezcla = 1
func _process(_delta: float) -> bool:
	if not is_instance_valid(cuerpo): return false
	fotograma += 1
	cuerpo.rotation.y = PI / 2 if fotograma <= 80 else -PI / 2
	cuerpo.avanzar(1.0 / 60, fotograma <= 160)
	if fotograma in [40, 60, 120, 140]: guardar.call_deferred("perfil_%03d" % fotograma)
	if fotograma == 180:
		cuerpo.rotation.y = PI / 4
		camara.size = 0.58
		camara.position.y = 1.59
		camara.look_at(Vector3(0, 1.59, 0))
		guardar.call_deferred("cabeza")
	if fotograma >= 190: terminar.call_deferred()
	return false
func guardar(nombre: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(CARPETA + ("v3_" if anterior else "v4_") + nombre + ".png"))
func terminar() -> void: quit()
