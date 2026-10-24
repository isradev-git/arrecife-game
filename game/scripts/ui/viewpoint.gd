extends Control

const AmbientFiebre = preload("res://scripts/ui/ambient_fiebre.gd")

signal activated(hotspot: Dictionary)
var screen: Dictionary
var image := TextureRect.new()
var ambient: Control
var spots: Array[Button] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(image)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_SCALE
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = true
	resized.connect(layout_spots)

func show_screen(value: Dictionary) -> void:
	screen = value
	image.texture = load("res://assets/backgrounds/candidates/%s.png" % screen.art)
	if is_instance_valid(ambient):
		image.remove_child(ambient)
		ambient.queue_free()
	ambient = null
	if screen.art == "fiebre_multitud_v2":
		ambient = AmbientFiebre.new()
		image.add_child(ambient)
		ambient.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		set_ambient_motion(not State.settings.reduced_motion)
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
		if hotspot.type == "NAVIGATION":
			var marker := Panel.new()
			marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var style := StyleBoxFlat.new()
			style.bg_color = Color(0.025, 0.055, 0.065, 0.42)
			style.border_color = Color(0.87, 0.73, 0.54, 0.72)
			style.set_border_width_all(1)
			style.set_corner_radius_all(10)
			marker.add_theme_stylebox_override("panel", style)
			marker.size = Vector2(20, 20)
			var door := Line2D.new()
			door.points = PackedVector2Array([Vector2(6, 16), Vector2(6, 5), Vector2(14, 5), Vector2(14, 16), Vector2(6, 16)])
			door.width = 1.5
			door.default_color = Color(0.97, 0.80, 0.57, 0.88)
			door.antialiased = true
			marker.add_child(door)
			var knob := ColorRect.new()
			knob.color = door.default_color
			knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
			knob.position = Vector2(11, 10)
			knob.size = Vector2(2, 2)
			marker.add_child(knob)
			node.add_child(marker)
		else:
			var marker := Panel.new()
			marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var style := StyleBoxFlat.new()
			style.bg_color = Color(0.91, 0.75, 0.52, 0.78)
			style.border_color = Color(0.04, 0.08, 0.10, 0.9)
			style.set_border_width_all(1)
			style.set_corner_radius_all(5)
			marker.add_theme_stylebox_override("panel", style)
			marker.size = Vector2(10, 10)
			node.add_child(marker)
	set_hints(State.settings.hints)
	layout_spots()

func set_hints(value: bool) -> void:
	for node in spots:
		node.get_child(0).visible = value

func set_ambient_motion(enabled: bool) -> void:
	if is_instance_valid(ambient):
		ambient.set_motion_enabled(enabled)

func art_rect() -> Rect2:
	var ratio := image.texture.get_size().aspect() if image.texture else 16.0 / 9.0
	var height := size.x / ratio
	return Rect2(Vector2(0, maxf(0, (size.y - height) * 0.5)), Vector2(size.x, minf(size.y, height)))

func layout_spots() -> void:
	var area := art_rect()
	var ratio := image.texture.get_size().aspect() if image.texture else 16.0 / 9.0
	var drawn := Vector2(size.x, size.x / ratio)
	image.position = (size - drawn) * 0.5
	image.size = drawn
	for node in spots:
		var bounds: Array = node.get_meta("hotspot").bounds
		var side := 48.0 if get_window().size.y < 500 else 36.0
		var extent := Vector2(side, side)
		var center := image.position + drawn * Vector2(bounds[0] + bounds[2]*0.5, bounds[1] + bounds[3]*0.5)
		node.size = extent
		node.position = Vector2(clampf(center.x - extent.x*0.5, area.position.x, area.end.x-extent.x), clampf(center.y - extent.y*0.5, area.position.y, area.end.y-extent.y))
		node.get_child(0).position = (extent - node.get_child(0).size) * 0.5
