extends Node3D

@export var escenario: Script = preload("res://pasarela.gd")
@export var nombre_tramo := "EL ARRECIFE  /  ESTUDIO DE PASARELA"

var jugadora: CharacterBody3D
var camara: Camera3D
var pausa := false
var aviso := Label.new()
var boton_pausa := Button.new()

func _ready() -> void:
	add_child(escenario.new())
	jugadora = preload("res://jugadora.gd").new()
	add_child(jugadora)
	camara = Camera3D.new()
	camara.projection = Camera3D.PROJECTION_PERSPECTIVE
	camara.fov = 29
	camara.position = Vector3(0, 3.87, 24)
	add_child(camara)
	camara.look_at(Vector3(0, 1.8, 0))
	var interfaz := CanvasLayer.new()
	add_child(interfaz)
	var titulo := Label.new()
	titulo.text = nombre_tramo
	titulo.position = Vector2(32, 26)
	titulo.add_theme_font_size_override("font_size", 19)
	interfaz.add_child(titulo)
	var instrucciones := Label.new()
	instrucciones.text = "A / D · Flechas · Clic para caminar       Espacio: pausa"
	instrucciones.position = Vector2(32, 655)
	interfaz.add_child(instrucciones)
	aviso.position = Vector2(32, 682)
	aviso.text = "Tramo 3D de 42 m · Sota y acabado visual en desarrollo"
	aviso.add_theme_font_size_override("font_size", 13)
	interfaz.add_child(aviso)
	var fila := HBoxContainer.new()
	fila.position = Vector2(950, 26)
	interfaz.add_child(fila)
	boton_pausa.text = "Pausa"
	boton_pausa.pressed.connect(cambiar_pausa)
	fila.add_child(boton_pausa)
	var laboratorio := Button.new()
	laboratorio.text = "Laboratorio"
	laboratorio.pressed.connect(func(): get_tree().change_scene_to_file("res://laboratorio.tscn"))
	fila.add_child(laboratorio)

func cambiar_pausa() -> void:
	pausa = not pausa
	boton_pausa.text = "Reanudar" if pausa else "Pausa"

func _input(evento: InputEvent) -> void:
	if evento is InputEventKey and evento.pressed and not evento.echo and evento.keycode == KEY_SPACE:
		cambiar_pausa()
		get_viewport().set_input_as_handled()

func _unhandled_input(evento: InputEvent) -> void:
	if evento is InputEventMouseButton and evento.pressed and evento.button_index == MOUSE_BUTTON_LEFT:
		var punto = Plane(Vector3.UP, 0).intersects_ray(camara.project_ray_origin(evento.position), camara.project_ray_normal(evento.position))
		if punto != null:
			jugadora.destino = clampf(punto.x, -3.5, 37.5)

func _notification(que: int) -> void:
	if que == NOTIFICATION_APPLICATION_FOCUS_OUT and is_instance_valid(jugadora):
		jugadora.destino = INF
		pausa = true
		boton_pausa.text = "Reanudar"

func _physics_process(delta: float) -> void:
	if pausa: return
	jugadora.avanzar(delta)
	var objetivo := clampf(jugadora.position.x + jugadora.direccion * 0.8, -0.3, 34.3)
	camara.position.x = lerpf(camara.position.x, objetivo, 1.0 - exp(-delta * 4.0))
