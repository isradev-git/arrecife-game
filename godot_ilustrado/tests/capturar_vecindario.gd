extends SceneTree
var visor: Node3D
const CARPETA = "res://../trabajo/arte/revisiones/demo_velvet_3d_v2/"
func _initialize() -> void: call_deferred("capturar")
func capturar() -> void:
	visor=load("res://sota_360.tscn").instantiate()
	root.add_child(visor)
	visor.rotacion_automatica=false
	await process_frame
	await RenderingServer.frame_post_draw
	for hijo in visor.get_children():
		if hijo is CanvasLayer:hijo.hide()
	for nombre in ["jefa","vecina_tecnica","vecino_visor","vecina_brazo"]:
		visor.cuerpo.free()
		visor.cuerpo=load("res://cuerpo.gd").new()
		visor.cuerpo.estudio_sota=true
		visor.cuerpo.modelo_sota=load("res://assets/velvet_3d_v2/"+nombre+".glb")
		visor.add_child(visor.cuerpo)
		visor.angulo=.5
		visor.altura=1.05
		visor.distancia=2.8
		await foto(nombre+"_cuerpo")
		if nombre=="jefa":
			visor.altura=1.57
			visor.distancia=.83
			await foto("jefa_retrato")
			visor.angulo=-.5
			await foto("jefa_contraperfil")
			visor.altura=1.08
			visor.distancia=2.8
			visor.angulo=PI
			await foto("jefa_espalda")
	quit()
func foto(nombre: String) -> void:
	for i in range(12):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(ProjectSettings.globalize_path(CARPETA+nombre+".png"))
	print("Captura ",nombre)
