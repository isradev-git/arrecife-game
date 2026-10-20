extends Control

signal activated(hotspot: Dictionary)
var screen: Dictionary
var image := TextureRect.new()
var spots: Array[Button] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(image)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_SCALE
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(layout_spots)

func show_screen(value: Dictionary) -> void:
	screen = value
	image.texture = load("res://assets/backgrounds/candidates/%s.png" % screen.art)
	for node in spots:
		remove_child(node)
		node.queue_free()
	spots.clear()
	for hotspot in screen.hotspots:
		if not State.matches(hotspot.get("visible_if", {})):
			continue
		var node := Button.new()
		node.accessibility_name = hotspot.label
		node.tooltip_text = hotspot.label
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		node.set_meta("hotspot", hotspot)
		for style in ["normal", "hover", "pressed", "disabled"]:
			node.add_theme_stylebox_override(style, StyleBoxEmpty.new())
		var focus := StyleBoxFlat.new()
		focus.bg_color = Color.TRANSPARENT
		focus.border_color = Color(0.84, 0.66, 0.42, 0.7)
		focus.set_border_width_all(1)
		node.add_theme_stylebox_override("focus", focus)
		node.pressed.connect(func(): activated.emit(hotspot))
		add_child(node)
		spots.append(node)
		var glint := Panel.new()
		glint.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var dot := StyleBoxFlat.new()
		dot.bg_color = Color(0.91, 0.75, 0.52, 0.75)
		dot.border_color = Color(0.08, 0.13, 0.14, 0.8)
		dot.set_border_width_all(1)
		dot.set_corner_radius_all(5)
		glint.add_theme_stylebox_override("panel", dot)
		glint.size = Vector2(9, 9)
		node.add_child(glint)
	set_hints(State.settings.hints)
	layout_spots()

func set_hints(value: bool) -> void:
	for node in spots:
		node.get_child(0).visible = value

func art_rect() -> Rect2:
	var ratio := image.texture.get_size().aspect() if image.texture else 16.0 / 9.0
	var extent := Vector2(minf(size.x, size.y * ratio), minf(size.y, size.x / ratio))
	return Rect2((size - extent) * 0.5, extent)

func layout_spots() -> void:
	var area := art_rect()
	image.position = area.position
	image.size = area.size
	for node in spots:
		var bounds: Array = node.get_meta("hotspot").bounds
		var extent := Vector2(maxf(56, area.size.x * bounds[2]), maxf(56, area.size.y * bounds[3]))
		var center := area.position + area.size * Vector2(bounds[0] + bounds[2]*0.5, bounds[1] + bounds[3]*0.5)
		node.size = extent
		node.position = Vector2(clampf(center.x - extent.x*0.5, area.position.x, area.end.x-extent.x), clampf(center.y - extent.y*0.5, area.position.y, area.end.y-extent.y))
		node.get_child(0).position = (extent - Vector2(9, 9)) * 0.5
