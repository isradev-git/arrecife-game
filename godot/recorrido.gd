extends "res://revision_escala.gd"

const MOTION = preload("res://movimiento.gd")

var motion := MOTION.new()
var body := CharacterBody2D.new()
var pressed_keys: Dictionary = {}
var arrival_pose := -1
var destination_name := ""


func _ready() -> void:
	super._ready()
	body.position = ground
	add_child(body)
	var footprint := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(24, 14)
	footprint.shape = shape
	footprint.position.y = -7.0
	body.add_child(footprint)
	sota.reparent(body)
	# El centro de la pasarela es el plano transitable; el mobiliario del fondo no lo bloquea.
	for x in [MOTION.MIN_X - 20.0, MOTION.MAX_X + 20.0]:
		var wall := StaticBody2D.new()
		wall.position = Vector2(x, GROUND_Y)
		var wall_shape := CollisionShape2D.new()
		var rectangle := RectangleShape2D.new()
		rectangle.size = Vector2(16, 160)
		wall_shape.shape = rectangle
		wall.add_child(wall_shape)
		add_child(wall)
	get_window().focus_exited.connect(cancel_movement)
	update_status()


func show_pose(index: int) -> void:
	# shortcut: perfiles estáticos para validar el control; T05 añadirá pasos sincronizados.
	super.show_pose(index)
	if sota.get_parent() == body:
		sota.position = Vector2.ZERO


func build_controls() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := review_panel
	panel.position = Vector2(20, 20)
	layer.add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	panel.add_child(column)
	var title := Label.new()
	title.text = "VELVET · Prueba de recorrido"
	column.add_child(title)
	var help := Label.new()
	help.text = "Flechas / A D · Clic: caminar · Esc: parar"
	column.add_child(help)
	var row := HBoxContainer.new()
	column.add_child(row)
	add_button(row, "Junto a Jefa", go_to.bind(1260.0, 0, "Jefa"))
	add_button(row, "Junto al guardia", go_to.bind(300.0, 1, "guardia"))
	add_button(row, "Junto al acceso", go_to.bind(1480.0, 0, "acceso"))
	add_button(row, "Revisión visual", get_tree().change_scene_to_file.bind("res://revision_escala.tscn"))
	column.add_child(status)


func go_to(x: float, facing: int = -1, label: String = "") -> void:
	if motion.go_to(x):
		arrival_pose = facing
		destination_name = label
		pressed_keys.clear()


func cancel_movement() -> void:
	motion.stop()
	pressed_keys.clear()
	body.velocity = Vector2.ZERO
	arrival_pose = -1
	destination_name = ""
	if is_inside_tree():
		update_status()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		if key in [KEY_A, KEY_D, KEY_LEFT, KEY_RIGHT]:
			if not event.echo:
				if event.pressed:
					pressed_keys[key] = true
					motion.target = null
					arrival_pose = -1
					destination_name = ""
				else:
					pressed_keys.erase(key)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ESCAPE and event.pressed and not event.echo:
			cancel_movement()
			get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var point := get_global_mouse_position()
		if BOOTH_RECT.has_point(point):
			go_to(300.0, 1, "guardia")
		elif counter.get_rect().has_point(counter.to_local(point)) or staff.get_rect().has_point(staff.to_local(point)):
			go_to(1260.0, 0, "Jefa")
		elif access_companion.get_rect().has_point(access_companion.to_local(point)):
			go_to(1580.0, 0, "acompañante")
		elif access_person.get_rect().has_point(access_person.to_local(point)):
			go_to(1480.0, 0, "acceso")
		elif point.y >= BACK_EDGE_Y:
			go_to(point.x, -1, "")
		get_viewport().set_input_as_handled()


func _physics_process(delta: float) -> void:
	var intent := float(int(KEY_D in pressed_keys or KEY_RIGHT in pressed_keys) - int(KEY_A in pressed_keys or KEY_LEFT in pressed_keys))
	advance(delta, intent)


func advance(delta: float, intent: float) -> void:
	var previous := body.position.x
	var next: float = motion.step(previous, delta, intent)
	body.velocity = Vector2(motion.velocity, 0)
	var collision := body.move_and_collide(Vector2(next - previous, 0))
	if collision != null:
		motion.stop()
		arrival_pose = -1
		destination_name = ""
		body.velocity = Vector2.ZERO
	ground = Vector2(body.position.x, GROUND_Y)
	if not is_equal_approx(previous, body.position.x):
		var facing := 0 if body.position.x > previous else 1
		if facing != pose_index:
			show_pose(facing)
	if motion.arrived and arrival_pose >= 0:
		show_pose(arrival_pose)
	if motion.velocity == 0.0:
		body.velocity = Vector2.ZERO
	update_status()


func update_status() -> void:
	var state := "Detenida" if motion.velocity == 0.0 else "Caminando"
	if destination_name != "":
		state += " · " + ("Junto a " if motion.target == null else "Hacia ") + destination_name
	status.text = "%s · x %.0f · Altura 252 · Sprite provisional sin animación" % [state, ground.x]
