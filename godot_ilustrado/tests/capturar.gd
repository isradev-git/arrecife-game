extends SceneTree
var escena: Node3D
var fotograma := 0
var carpeta := "res://../trabajo/arte/revisiones/sota_prendas_3d_v5/"

func _initialize() -> void: call_deferred("preparar")
func preparar() -> void:
	escena=load("res://laboratorio.tscn").instantiate()
	root.add_child(escena)
	if not escena.cuerpo.estudio_sota: carpeta="res://../trabajo/arte/revisiones/locomocion_ilustrada_v1/"
	escena.set_physics_process(false)
	escena.automatico=true

func _process(_delta: float) -> bool:
	if not is_instance_valid(escena): return false
	fotograma+=1
	escena.automatico=fotograma<320
	escena.simular(1.0/60)
	escena.estado.text="Prueba automática · %.2f s · %s · mezcla %.2f" % [fotograma/60.0,"Derecha" if escena.direccion>0 else "Izquierda",escena.cuerpo.mezcla]
	if fotograma==100 and escena.cuerpo.mezcla<=0.99:
		push_error("La captura debe mostrar marcha real")
		quit(1)
		return false
	if fotograma in [45,100,175,250,350]: guardar.call_deferred(fotograma)
	if fotograma>=360: terminar.call_deferred()
	return false

func guardar(numero: int) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(carpeta+"fase_%03d.png"%numero))

func terminar() -> void:
	escena.free()
	quit()
