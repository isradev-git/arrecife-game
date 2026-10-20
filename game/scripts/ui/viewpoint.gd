extends Control

signal activated(hotspot: Dictionary)
var screen: Dictionary
var image := TextureRect.new()
var spots: Array[Button] = []
var hints := true
var mobile_list := ScrollContainer.new()
var mobile_column := VBoxContainer.new()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(image)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_SCALE
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(mobile_list)
	mobile_list.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	mobile_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mobile_list.add_child(mobile_column)
	resized.connect(layout_spots)

func show_screen(value: Dictionary) -> void:
	screen = value
	image.texture = load("res://assets/backgrounds/candidates/%s.png" % screen.art)
	for node in spots:
		remove_child(node)
		node.queue_free()
	spots.clear()
	GameUI.clear(mobile_column)
	for hotspot in screen.hotspots:
		if not State.matches(hotspot.get("visible_if", {})):
			continue
		var mobile_button := GameUI.button(mobile_column, hotspot.label, func(): activated.emit(hotspot))
		mobile_button.set_meta("hotspot", hotspot)
		var node := Button.new()
		node.text = {"NAVIGATION":">", "PERSON":"?", "TERMINAL":"T", "DOCUMENT":"=", "DEVICE":"D", "SPECIAL_EVENT":"v"}.get(hotspot.type, "o")
		node.accessibility_name = hotspot.label
		node.tooltip_text = hotspot.label
		node.add_theme_font_size_override("font_size", 24)
		node.set_meta("hotspot", hotspot)
		node.add_theme_stylebox_override("normal", GameUI.box(Color(0.04,0.08,0.10,0.82), Color("93856b")))
		node.mouse_entered.connect(func(): node.modulate.a = 1.0)
		node.mouse_exited.connect(func(): node.modulate.a = 1.0 if hints else 0.35)
		node.focus_entered.connect(func(): node.modulate.a = 1.0)
		node.pressed.connect(func(): activated.emit(hotspot))
		add_child(node)
		spots.append(node)
		var caption := GameUI.label(node, hotspot.get("short_label", hotspot.label), 16)
		caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.position = Vector2(-48, 62)
		caption.size = Vector2(minf(160, caption.get_theme_default_font().get_string_size(caption.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x + 12), 44)
		caption.add_theme_color_override("font_shadow_color", Color.BLACK)
		caption.add_theme_constant_override("shadow_outline_size", 8)
	set_hints(State.settings.hints)
	layout_spots()

func set_hints(value: bool) -> void:
	hints = value
	for node in spots:
		node.modulate.a = 1.0 if hints else 0.35

func art_rect() -> Rect2:
	var ratio := image.texture.get_size().aspect() if image.texture else 16.0 / 9.0
	var extent := Vector2(minf(size.x, size.y * ratio), minf(size.y, size.x / ratio))
	return Rect2(Vector2.ZERO if size.x < 700 else (size - extent) * 0.5, extent)

func layout_spots() -> void:
	var area := art_rect()
	image.position = area.position
	image.size = area.size
	mobile_list.visible = size.x < 700
	mobile_list.position = Vector2(0, area.end.y + 12)
	mobile_list.size = Vector2(size.x, maxf(0, size.y - area.end.y - 12))
	for node in spots:
		node.visible = size.x >= 700
		var bounds: Array = node.get_meta("hotspot").bounds
		var extent := Vector2(64, 60)
		var center := area.position + area.size * Vector2(bounds[0] + bounds[2]*0.5, bounds[1] + bounds[3]*0.5)
		node.size = extent
		node.position = Vector2(clampf(center.x - extent.x*0.5, area.position.x, area.end.x-extent.x), clampf(center.y - extent.y*0.5, area.position.y, area.end.y-extent.y))

		var caption := node.get_child(0) as Label
		caption.position.x = clampf((64 - caption.size.x) * 0.5, area.position.x - node.position.x, area.end.x - node.position.x - caption.size.x)
