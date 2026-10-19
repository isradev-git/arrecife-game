extends CharacterBody3D

const CUERPO = preload("res://cuerpo.gd")
var cuerpo: Node3D
var destino := INF
var direccion := 1.0
var objetivo_direccion := 1.0
var giro := false
var desplazamiento_real := 0.0

func _ready() -> void:
	var colision := CollisionShape3D.new()
	var capsula := CapsuleShape3D.new()
	capsula.radius = 0.19
	capsula.height = 1.7
	colision.shape = capsula
	colision.position.y = 0.85
	add_child(colision)
	cuerpo = CUERPO.new()
	cuerpo.estudio_sota = true
	cuerpo.rotation.y = PI / 2
	add_child(cuerpo)

func avanzar(delta: float) -> void:
	var entrada := float(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)) - float(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT))
	if entrada != 0:
		destino = INF
	elif is_finite(destino):
		var distancia := destino - position.x
		if absf(distancia) > 0.10:
			entrada = signf(distancia)
		else:
			destino = INF
	if entrada != 0:
		objetivo_direccion = entrada
		giro = absf(angle_difference(cuerpo.rotation.y, objetivo_direccion * PI / 2)) > 0.001
		# La mezcla tarda 0,2 s en frenar: anticipar el obstáculo evita caminar contra él.
		if test_move(global_transform, Vector3(entrada * 0.18, 0, 0)):
			entrada = 0
			destino = INF
	var movimiento: Vector3 = cuerpo.avanzar(delta, entrada != 0 and not giro)
	if giro and cuerpo.mezcla <= 0.001:
		cuerpo.rotation.y = rotate_toward(cuerpo.rotation.y, objetivo_direccion * PI / 2, delta * 9)
		if absf(angle_difference(cuerpo.rotation.y, objetivo_direccion * PI / 2)) < 0.001:
			direccion = objetivo_direccion
			giro = false
	var anterior := position.x
	velocity = Vector3((cuerpo.basis * movimiento).x / delta, -1.0, 0)
	move_and_slide()
	desplazamiento_real = position.x - anterior
