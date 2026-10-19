extends SceneTree

var escena: Node3D
var fotograma := 0
var anterior := "--anterior" in OS.get_cmdline_user_args()
const CARPETA = "res://../trabajo/arte/revisiones/sota_equipo_3d_v2/"

func _initialize() -> void: call_deferred("preparar")
func preparar() -> void:
	escena = preload("res://laboratorio.tscn").instantiate()
	escena.modelo_sota = preload("res://assets/sota_3d_v2/sota.glb")
	root.add_child(escena)
	escena.set_physics_process(false)
	for nodo in escena.get_children():
		if nodo is CanvasLayer: nodo.visible = false
	escena.camara.size = 1.1
	escena.camara.position = Vector3(0, 1.08, 7)
	escena.camara.look_at(Vector3(0, 1.08, 0))
	escena.cuerpo.mezcla = 1.0
	if anterior:
		var original = preload("res://assets/sota_3d_v1/sota.glb").instantiate()
		for nombre in ["Cyberdeck", "Marco cyberdeck", "Indicador cyberdeck"]:
			escena.cuerpo.esqueleto.get_node(nombre).mesh = original.find_child(nombre, true, false).mesh
		original.free()

func _process(_delta: float) -> bool:
	if not is_instance_valid(escena): return false
	fotograma += 1
	escena.cuerpo.rotation.y = PI / 2 if fotograma <= 80 else -PI / 2
	escena.cuerpo.avanzar(1.0 / 60, true)
	if fotograma % 20 == 0: guardar.call_deferred(fotograma)
	if fotograma >= 160: terminar.call_deferred()
	return false

func guardar(numero: int) -> void:
	await RenderingServer.frame_post_draw
	var nombre := "%s_%s_%03d.png" % ["antes" if anterior else "despues", "derecha" if numero <= 80 else "izquierda", numero]
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(CARPETA + nombre))

func terminar() -> void:
	escena.free()
	quit()
