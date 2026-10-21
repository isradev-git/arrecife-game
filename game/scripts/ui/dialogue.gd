extends Control

signal finished
var dialogue_id := ""
var node_id := ""
var content: Dictionary
var column: VBoxContainer
var sota: TextureRect
var other: TextureRect

func start(id: String) -> void:
	dialogue_id = id
	content = Content.dialogues[id]
	GameUI.clear(self)
	var dim := ColorRect.new()
	dim.color = Color(0.015,0.025,0.035,0.94)
	add_child(dim)
	GameUI.fill(dim)
	var margins := GameUI.margin(self, 24)
	GameUI.fill(margins)
	var row := HBoxContainer.new()
	margins.add_child(row)
	sota = GameUI.portrait(row, "sota")
	sota.custom_minimum_size.x = 86 if size.x < 700 else 200
	var center := VBoxContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(center)
	GameUI.label(center, "CONVERSACIÓN", 16)
	column = GameUI.scroll(center)
	GameUI.button(center, "Volver a la escena", func(): finished.emit())
	if not content.other.is_empty():
		other = GameUI.portrait(row, content.other)
		other.custom_minimum_size.x = 86 if size.x < 700 else 200
	else:
		other = null
	resized.connect(func():
		sota.custom_minimum_size.x = 86 if size.x < 700 else 200
		if other: other.custom_minimum_size.x = sota.custom_minimum_size.x)
	advance(content.start)

func advance(id: String) -> void:
	node_id = id
	var entry: Dictionary = content.nodes[id]
	if entry.has("effects"):
		State.apply(entry.effects)
	GameUI.clear(column)
	GameUI.label(column, "SOTA" if entry.speaker == "sota" else "LA JEFA", 20).modulate = GameUI.AMBER
	GameUI.label(column, entry.text, 28 if State.settings.large_text else 24)
	sota.modulate = Color.WHITE if entry.speaker == "sota" else Color("647074")
	if other:
		other.modulate = Color.WHITE if entry.speaker != "sota" else Color("647074")
	if entry.has("next"):
		GameUI.button(column, "Continuar >", func(): advance(entry.next))
	for choice in entry.get("choices", []):
		if State.matches(choice.get("if", {})):
			var button := GameUI.button(column, choice.text, func(): choose(choice))
			var main: bool = choice.get("role", "info") == "main"
			var accent := Color("e9c46a") if main else Color("aeb9b7")
			button.add_theme_color_override("font_color", accent)
			button.add_theme_color_override("font_hover_color", accent)
			button.add_theme_color_override("font_pressed_color", accent)
			button.add_theme_stylebox_override("normal", GameUI.box(Color("24291e") if main else Color("182229"), accent))
			button.add_theme_stylebox_override("hover", GameUI.box(Color("343322") if main else Color("27353a"), accent))
			button.accessibility_name = ("Avanza la misión: " if main else "Pregunta u opción secundaria: ") + choice.text

func choose(choice: Dictionary) -> void:
	State.data.choices[dialogue_id + ":" + node_id] = choice.text
	State.apply(choice.get("effects", {}))
	if choice.get("end", false):
		finished.emit()
	else:
		advance(choice.next)
