extends Node3D

var cuerpo: Node3D
var camara: Camera3D
var angulo := 0.4
var altura := 1.1
var distancia := 3.4
var rotacion_automatica := true
var marcha := false

func _ready() -> void:
	var ambiente := WorldEnvironment.new()
	ambiente.environment = Environment.new()
	ambiente.environment.background_mode = Environment.BG_COLOR
	ambiente.environment.background_color = Color("111c24")
	ambiente.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	ambiente.environment.ambient_light_energy = 0.55
	add_child(ambiente)
	for datos in [[Vector3(-30, -35, 0), Color("ffe3c8"), 1.0], [Vector3(-20, 140, 0), Color("8dbbc9"), 0.65]]:
		var luz := DirectionalLight3D.new()
		luz.rotation_degrees = datos[0]
		luz.light_color = datos[1]
		luz.light_energy = datos[2]
		add_child(luz)
	cuerpo = preload("res://cuerpo.gd").new()
	cuerpo.estudio_sota = true
	if "--anterior" in OS.get_cmdline_user_args(): cuerpo.modelo_sota = preload("res://assets/sota_3d_v6/sota.glb")
	add_child(cuerpo)
	camara = Camera3D.new()
	camara.fov = 38
	add_child(camara)
	var capa := CanvasLayer.new()
	add_child(capa)
	var panel := VBoxContainer.new()
	panel.position = Vector2(28, 25)
	capa.add_child(panel)
	var titulo := Label.new()
	titulo.text = "SOTA / ESTUDIO 360°"
	titulo.add_theme_font_size_override("font_size", 24)
	panel.add_child(titulo)
	var ayuda := Label.new()
	ayuda.text = "Arrastra para girar · Rueda para acercar · Botón derecho para elevar la vista"
	panel.add_child(ayuda)
	var fila := HBoxContainer.new()
	panel.add_child(fila)
	for dato in [["Giro automático", func(): rotacion_automatica = not rotacion_automatica], ["Reposo / marcha", func(): marcha = not marcha], ["Volver a Velvet", func(): get_tree().change_scene_to_file("res://demo_velvet.tscn")]]:
		var boton := Button.new()
		boton.text = dato[0]
		boton.pressed.connect(dato[1])
		fila.add_child(boton)
	actualizar_camara()

func actualizar_camara() -> void:
	camara.position = Vector3(sin(angulo) * distancia, altura + 0.12, cos(angulo) * distancia)
	camara.look_at(Vector3(0, altura, 0))

func _process(delta: float) -> void:
	cuerpo.avanzar(delta, marcha)
	if rotacion_automatica: angulo += delta * 0.25
	actualizar_camara()

func _unhandled_input(evento: InputEvent) -> void:
	if evento is InputEventMouseMotion:
		if evento.button_mask & MOUSE_BUTTON_MASK_LEFT:
			rotacion_automatica = false
			angulo -= evento.relative.x * 0.008
		if evento.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			altura = clampf(altura + evento.relative.y * 0.003, 0.15, 1.72)
	if evento is InputEventMouseButton and evento.pressed:
		if evento.button_index == MOUSE_BUTTON_WHEEL_UP: distancia = maxf(0.65, distancia * 0.9)
		if evento.button_index == MOUSE_BUTTON_WHEEL_DOWN: distancia = minf(5, distancia * 1.1)
