extends "res://recorrido_3d.gd"

# Propuesta de conversación cotidiana: fuentes y alcance en la memoria de la demo.
const ENCUENTROS = [
	{"x": 0.0, "nombre": "Salida de personal", "voz": "SOTA", "texto": "Una salida para quienes trabajan aquí. El lector está al otro lado del cristal.\n\nEn el Arrecife, bajar es fácil. Subir exige permiso."},
	{"x": 9.0, "nombre": "Mirar la ciudad", "voz": "SOTA", "texto": "Otra pasarela detrás de ésta. Y otra más abajo.\n\nLas cotas no son los pisos de una torre. Son franjas de altura que atraviesan la ciudad entera. Aquí, en la Fiebre, seguimos bajo el humo."},
	{"x": 19.0, "nombre": "Hablar en la recepción", "voz": "RECEPCIÓN", "texto": "—¿Buscas a alguien?\n\n—Hoy sólo estoy de paso —dice Sota.\n\n—Entonces puedes quedarte un momento. Pero déjame el mostrador libre."},
	{"x": 33.5, "nombre": "Examinar la reparación", "voz": "SOTA", "texto": "La abrazadera es nueva. El tubo lleva aquí mucho más tiempo.\n\nEn esta ciudad cada arreglo se apoya sobre el anterior. Desmontarlo todo saldría más caro."}
]
var cercano := -1
var lectura := PanelContainer.new()
var texto := Label.new()
var voz := Label.new()
var interactuar := Button.new()
var pausa_antes := false

func _ready() -> void:
	escenario = preload("res://velvet.gd")
	nombre_tramo = "EL ARRECIFE  /  VELVET"
	super._ready()
	jugadora.position.x = 9
	camara.position.x = 9
	aviso.text = "LA FIEBRE · COTA 4"
	var interfaz := CanvasLayer.new()
	add_child(interfaz)
	var modelo := Button.new()
	modelo.text = "Sota · 360°"
	modelo.position = Vector2(1140,26)
	modelo.pressed.connect(func(): get_tree().change_scene_to_file("res://sota_360.tscn"))
	interfaz.add_child(modelo)
	interactuar.position = Vector2(480,604)
	interactuar.custom_minimum_size = Vector2(320,40)
	interactuar.pressed.connect(abrir_lectura)
	interfaz.add_child(interactuar)
	lectura.position = Vector2(290,375)
	lectura.size = Vector2(700,245)
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color("101c29f5")
	estilo.border_color = Color("936957")
	estilo.set_border_width_all(1)
	estilo.content_margin_left = 26
	estilo.content_margin_right = 26
	estilo.content_margin_top = 18
	estilo.content_margin_bottom = 18
	lectura.add_theme_stylebox_override("panel",estilo)
	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation",12)
	lectura.add_child(columna)
	voz.add_theme_color_override("font_color",Color("e5b78e"))
	columna.add_child(voz)
	texto.custom_minimum_size = Vector2(640,120)
	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.add_theme_font_size_override("font_size",20)
	columna.add_child(texto)
	var cerrar := Button.new()
	cerrar.text = "Seguir caminando  ·  Esc"
	cerrar.pressed.connect(cerrar_lectura)
	columna.add_child(cerrar)
	interfaz.add_child(lectura)
	lectura.hide()

func _process(_delta: float) -> void:
	cercano = -1
	for i in range(ENCUENTROS.size()):
		if absf(jugadora.position.x-ENCUENTROS[i].x)<1.5: cercano = i
	interactuar.visible = cercano>=0 and not lectura.visible
	if cercano>=0: interactuar.text = "E · " + ENCUENTROS[cercano].nombre

func _physics_process(delta: float) -> void:
	if lectura.visible and not pausa_antes:
		# Completar la frenada del clip antes de mantener el reposo durante la lectura.
		jugadora.velocity = jugadora.cuerpo.basis * jugadora.cuerpo.avanzar(delta,false) / delta
		jugadora.velocity.y = -1
		jugadora.move_and_slide()
		return
	super._physics_process(delta)

func abrir_lectura() -> void:
	if cercano<0 or lectura.visible: return
	pausa_antes = pausa
	pausa = true
	jugadora.destino = INF
	voz.text = ENCUENTROS[cercano].voz
	texto.text = ENCUENTROS[cercano].texto
	lectura.show()
	interactuar.hide()

func cerrar_lectura() -> void:
	lectura.hide()
	pausa = pausa_antes
	boton_pausa.text = "Reanudar" if pausa else "Pausa"

func cambiar_pausa() -> void:
	if lectura.visible: return
	super.cambiar_pausa()

func _input(evento: InputEvent) -> void:
	if evento is InputEventKey and evento.pressed and not evento.echo:
		if evento.keycode == KEY_E:
			abrir_lectura()
			get_viewport().set_input_as_handled()
			return
		if evento.keycode == KEY_ESCAPE and lectura.visible:
			cerrar_lectura()
			get_viewport().set_input_as_handled()
			return
	super._input(evento)

func _unhandled_input(evento: InputEvent) -> void:
	if lectura.visible or pausa: return
	super._unhandled_input(evento)
