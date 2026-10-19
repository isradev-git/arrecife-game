extends Node3D

const CUERPO=preload("res://cuerpo.gd")
@export var modelo_sota: PackedScene = preload("res://assets/sota_3d_v7/sota.glb")
var cuerpo: Node3D
var camara: Camera3D
var estado := Label.new()
var automatico := false
var pausa := false
var lento := false
var destino := INF
var direccion := 1.0
var objetivo_direccion := 1.0
var giro := false
var tiempo := 0.0
var ultimodesplazamiento := Vector3.ZERO

func _ready() -> void:
	var entorno := WorldEnvironment.new()
	entorno.environment=Environment.new()
	entorno.environment.background_mode=Environment.BG_COLOR
	entorno.environment.background_color=Color("101921")
	entorno.environment.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
	entorno.environment.ambient_light_color=Color("9cbbc6")
	entorno.environment.ambient_light_energy=0.32
	add_child(entorno)
	var luz := DirectionalLight3D.new()
	luz.rotation_degrees=Vector3(-38,-32,0)
	luz.light_color=Color("f3d2b4")
	luz.light_energy=0.9
	luz.shadow_enabled=true
	add_child(luz)
	var relleno := DirectionalLight3D.new()
	relleno.rotation_degrees=Vector3(-15,135,0)
	relleno.light_color=Color("6dacc4")
	relleno.light_energy=0.2
	add_child(relleno)
	var suelo := MeshInstance3D.new()
	var plano := PlaneMesh.new()
	plano.size=Vector2(20,6)
	suelo.mesh=plano
	var material := StandardMaterial3D.new()
	material.albedo_color=Color("26343d")
	material.roughness=1.0
	suelo.material_override=material
	add_child(suelo)
	for i in range(-16,17):
		var marca := MeshInstance3D.new()
		var forma := BoxMesh.new()
		forma.size=Vector3(0.008,0.003,1.1 if i%2==0 else 0.5)
		marca.mesh=forma
		marca.position=Vector3(i*0.5,0.002,0)
		add_child(marca)
	cuerpo=CUERPO.new()
	cuerpo.modelo_sota=modelo_sota
	cuerpo.estudio_sota=not "--base" in OS.get_cmdline_user_args()
	cuerpo.rotation.y=PI/2
	add_child(cuerpo)
	camara=Camera3D.new()
	camara.projection=Camera3D.PROJECTION_ORTHOGONAL
	camara.size=4.3
	camara.position=Vector3(0,1.4,7)
	add_child(camara)
	camara.look_at(Vector3(0,0.95,0))
	interfaz()

func interfaz() -> void:
	var capa := CanvasLayer.new()
	add_child(capa)
	var panel := VBoxContainer.new()
	panel.position=Vector2(28,22)
	capa.add_child(panel)
	var titulo := Label.new()
	titulo.text="EL ARRECIFE · NUEVA BASE DE LOCOMOCIÓN"
	titulo.add_theme_font_size_override("font_size",23)
	panel.add_child(titulo)
	var nota := Label.new()
	nota.text=("Estudio 3D de Sota · Modelo y acabado en desarrollo" if cuerpo.estudio_sota else "Cuerpo técnico completo · No es el modelo final de Sota")+"\nFlechas / A–D o clic en el suelo · Espacio: pausa · R: reiniciar"
	panel.add_child(nota)
	var fila := HBoxContainer.new()
	panel.add_child(fila)
	boton(fila,"Marcha continua",func(): automatico=not automatico; destino=INF)
	boton(fila,"Pausa / reanudar",func(): pausa=not pausa)
	boton(fila,"0,25× / 1×",func(): lento=not lento)
	boton(fila,"+ Fotograma",func(): pausa=true; simular(1.0/60))
	boton(fila,"Reiniciar",reiniciar)
	boton(fila,"Pasarela 3D",func(): get_tree().change_scene_to_file("res://recorrido_3d.tscn"))
	panel.add_child(estado)
	var referencia := TextureRect.new()
	referencia.texture=preload("res://referencias/sota.png")
	referencia.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	referencia.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	referencia.position=Vector2(1020,165)
	referencia.size=Vector2(230,380)
	referencia.mouse_filter=Control.MOUSE_FILTER_IGNORE
	capa.add_child(referencia)
	var pie := Label.new()
	pie.position=Vector2(1020,555)
	pie.text="IDENTIDAD Y ACABADO OBJETIVO\nRetrato original de Sota"
	pie.add_theme_font_size_override("font_size",13)
	capa.add_child(pie)
	var aviso := Label.new()
	aviso.position=Vector2(28,670)
	aviso.text="Sin sprites pixelados · Sin recortes deformados · Desplazamiento procedente de la animación"
	capa.add_child(aviso)

func boton(panel: Node, texto: String, accion: Callable) -> void:
	var control := Button.new()
	control.text=texto
	control.pressed.connect(accion)
	panel.add_child(control)

func reiniciar() -> void:
	cuerpo.position=Vector3.ZERO
	cuerpo.rotation.y=PI/2
	cuerpo.mezcla=0.0
	cuerpo.recorrido=0.0
	direccion=1.0
	objetivo_direccion=1.0
	giro=false
	destino=INF
	automatico=false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode==KEY_SPACE:
			pausa=not pausa
			get_viewport().set_input_as_handled()
		if event.keycode==KEY_R:
			reiniciar()
			get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT:
		var punto=Plane(Vector3.UP,0).intersects_ray(camara.project_ray_origin(event.position),camara.project_ray_normal(event.position))
		if punto!=null:
			destino=clampf(punto.x,-2.3,2.3)
			automatico=false

func _notification(what: int) -> void:
	if what==NOTIFICATION_APPLICATION_FOCUS_OUT:
		destino=INF
		automatico=false
		pausa=true

func _physics_process(delta: float) -> void:
	if not pausa: simular(delta*(0.25 if lento else 1.0))
	estado.text="%s · %s · mezcla %.2f · recorrido %.2f m" % ["Pausa" if pausa else "Movimiento","Izquierda" if direccion<0 else "Derecha",cuerpo.mezcla,cuerpo.recorrido]

func simular(delta: float) -> void:
	tiempo+=delta
	var entrada := float(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT))-float(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT))
	if entrada!=0:
		destino=INF
		automatico=false
	elif automatico:
		if absf(cuerpo.position.x)>1.8: objetivo_direccion=-signf(cuerpo.position.x)
		entrada=objetivo_direccion
	elif is_finite(destino):
		var distancia := destino-cuerpo.position.x
		if absf(distancia)>0.12: entrada=signf(distancia)
		else: destino=INF
	if entrada!=0:
		objetivo_direccion=entrada
		if entrada!=direccion: giro=true
	# Adelantar la frenada evita animar la marcha contra el borde.
	if entrada*cuerpo.position.x>0 and absf(cuerpo.position.x)>2.38: entrada=0
	var andar := entrada!=0 and not giro
	ultimodesplazamiento=cuerpo.avanzar(delta,andar)
	if giro and cuerpo.mezcla<=0.001:
		cuerpo.rotation.y=rotate_toward(cuerpo.rotation.y,objetivo_direccion*PI/2,delta*9)
		if absf(angle_difference(cuerpo.rotation.y,objetivo_direccion*PI/2))<0.001:
			direccion=objetivo_direccion
			giro=false
	cuerpo.position+=cuerpo.basis*ultimodesplazamiento
	cuerpo.position.x=clampf(cuerpo.position.x,-2.5,2.5)
