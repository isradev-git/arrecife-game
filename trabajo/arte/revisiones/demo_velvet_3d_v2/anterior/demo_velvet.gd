extends "res://recorrido_3d.gd"

# Propuesta de conversación cotidiana: fuentes y alcance en la memoria de la demo.
const ENCUENTROS = [
	{"x": 0.0, "nombre": "Salida de personal", "lineas": [
		["SOTA", "La entrada de clientes tiene dos luces nuevas. La salida de personal sigue con el lector roto."],
		["SOTA", "Alguien ha vuelto a sujetar el cable con cinta."]]},
	{"x": 9.0, "nombre": "Observar la calle", "lineas": [
		["SOTA", "Bares, habitaciones por turnos, cabinas sensoriales. La Fiebre vende formas distintas de pasar la noche."],
		["SOTA", "Arriba cambia el aire. Aquí seguimos debajo del humo."]]},
	{"x": 16.4, "nombre": "Hablar con la jefa", "lineas": [
		["JEFA", "¿Vas a quedarte ahí? Aparta un poco. Están entrando clientes."],
		["SOTA", "¿El fondo de la Nómina cubre a todas las que trabajan aquí?"],
		["JEFA", "A las que aportan su cuota. El local es una cosa; nuestra caja, otra."],
		["SOTA", "¿Y cuando alguien necesita salir de un problema?"],
		["JEFA", "Miro qué cobertura tiene y qué podemos pagar. La caja no se llena sola."]]},
	{"x": 33.5, "nombre": "Examinar la reparación", "lineas": [
		["SOTA", "Abrazadera nueva, tubo viejo. Han cambiado sólo la pieza que perdía."],
		["SOTA", "Todavía gotea por la unión de arriba."]]}
]
var cercano := -1
var lectura := Control.new()
var retrato_sota := TextureRect.new()
var retrato_otro := TextureRect.new()
var siguiente := Button.new()
var indice_linea := 0
var iluminacion: Tween
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
	lectura.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	interfaz.add_child(lectura)
	var fondo := ColorRect.new()
	fondo.color = Color(0.015,0.025,0.045,0.86)
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	lectura.add_child(fondo)
	for datos in [[retrato_sota, Vector2(26,166), preload("res://referencias/sota.png")], [retrato_otro, Vector2(934,166), preload("res://referencias/jefa.png")]]:
		var retrato: TextureRect = datos[0]
		retrato.position = datos[1]
		retrato.size = Vector2(320,505)
		retrato.texture = datos[2]
		retrato.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		retrato.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		retrato.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lectura.add_child(retrato)
	var lugar := Label.new()
	lugar.position = Vector2(366,245)
	lugar.text = "LA FIEBRE  /  VELVET"
	lugar.add_theme_font_size_override("font_size",14)
	lugar.add_theme_color_override("font_color",Color("ab9190"))
	lectura.add_child(lugar)
	var panel := PanelContainer.new()
	panel.position = Vector2(352,290)
	panel.size = Vector2(576,230)
	lectura.add_child(panel)
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color("111a23f0")
	estilo.border_color = Color("806258")
	estilo.set_border_width_all(1)
	estilo.content_margin_left = 24
	estilo.content_margin_right = 24
	estilo.content_margin_top = 22
	estilo.content_margin_bottom = 22
	panel.add_theme_stylebox_override("panel",estilo)
	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation",18)
	panel.add_child(columna)
	voz.add_theme_font_size_override("font_size",17)
	voz.add_theme_color_override("font_color",Color("e5b78e"))
	columna.add_child(voz)
	texto.custom_minimum_size = Vector2(528,133)
	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.add_theme_font_size_override("font_size",23)
	columna.add_child(texto)
	siguiente.position = Vector2(728,544)
	siguiente.custom_minimum_size = Vector2(200,42)
	siguiente.pressed.connect(avanzar_linea)
	lectura.add_child(siguiente)
	var cerrar := Button.new()
	cerrar.position = Vector2(352,544)
	cerrar.custom_minimum_size = Vector2(225,42)
	cerrar.text = "Volver a la calle · Esc"
	cerrar.pressed.connect(cerrar_lectura)
	lectura.add_child(cerrar)
	lectura.hide()

func mostrar_linea() -> void:
	var lineas: Array = ENCUENTROS[cercano].lineas
	var linea: Array = lineas[indice_linea]
	voz.text = "SOTA" if linea[0] == "SOTA" else "LA JEFA"
	texto.text = linea[1]
	retrato_otro.visible = lineas.any(func(l): return l[0] != "SOTA")
	var apagado := Color(.3,.33,.39,1)
	if iluminacion: iluminacion.kill()
	iluminacion = create_tween().set_parallel(true)
	iluminacion.tween_property(retrato_sota,"modulate",Color.WHITE if linea[0] == "SOTA" else apagado,.16)
	iluminacion.tween_property(retrato_otro,"modulate",apagado if linea[0] == "SOTA" else Color.WHITE,.16)
	siguiente.text = "Terminar · E" if indice_linea == lineas.size()-1 else "Continuar · E"

func avanzar_linea() -> void:
	if not lectura.visible: return
	indice_linea += 1
	if indice_linea >= ENCUENTROS[cercano].lineas.size(): cerrar_lectura()
	else: mostrar_linea()

func _process(_delta: float) -> void:
	if lectura.visible: return
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
	indice_linea = 0
	mostrar_linea()
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
		if lectura.visible:
			if evento.keycode == KEY_ESCAPE: cerrar_lectura()
			elif evento.keycode in [KEY_E,KEY_SPACE,KEY_ENTER]: avanzar_linea()
			get_viewport().set_input_as_handled()
			return
		if evento.keycode == KEY_E:
			abrir_lectura()
			get_viewport().set_input_as_handled()
			return
	super._input(evento)

func _unhandled_input(evento: InputEvent) -> void:
	if lectura.visible or pausa: return
	super._unhandled_input(evento)
