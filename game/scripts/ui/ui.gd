class_name GameUI
extends RefCounted

const INK := Color("101a21")
const PAPER := Color("e8ddc6")
const AMBER := Color("d7a968")
const MUTED := Color("99aaa9")

static func box(color: Color, border: Color = Color("435456"), radius: int = 4) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style

static func theme() -> Theme:
	var result := Theme.new()
	result.default_font_size = 16
	result.set_color("font_color", "Label", PAPER)
	result.set_color("font_color", "Button", PAPER)
	result.set_color("font_hover_color", "Button", Color.WHITE)
	result.set_color("font_disabled_color", "Button", Color("687476"))
	result.set_stylebox("normal", "Button", box(Color("16252b")))
	result.set_stylebox("hover", "Button", box(Color("2e403f"), AMBER))
	result.set_stylebox("pressed", "Button", box(Color("46544a"), AMBER))
	result.set_stylebox("disabled", "Button", box(Color("172024"), Color("283235")))
	result.set_stylebox("focus", "Button", box(Color(0,0,0,0), AMBER))
	result.set_constant("separation", "VBoxContainer", 8)
	result.set_constant("separation", "HBoxContainer", 8)
	return result

static func fill(control: Control) -> void:
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

static func clear(parent: Node) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

static func label(parent: Node, text: String, font_size: int = 22, wrap: bool = true) -> Label:
	var node := Label.new()
	node.text = text
	var size := maxi(16, roundi(font_size * 0.65))
	if parent.get_window().size.y < 500:
		size = maxi(18, roundi(size * 1.15))
	node.add_theme_font_size_override("font_size", size)
	if wrap:
		node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(node)
	return node

static func button(parent: Node, text: String, callback: Callable) -> Button:
	var node := Button.new()
	node.text = text
	node.custom_minimum_size.y = 44 if parent.get_window().size.y < 500 else 36
	if parent.get_window().size.y < 500:
		node.add_theme_font_size_override("font_size", 18)
	node.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	node.focus_mode = Control.FOCUS_ALL
	node.pressed.connect(callback)
	parent.add_child(node)
	return node

static func action(parent: Node, text: String, callback: Callable) -> Button:
	var node := button(parent, text, callback)
	node.alignment = HORIZONTAL_ALIGNMENT_LEFT
	node.custom_minimum_size.y = 48
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for state in ["normal", "hover", "pressed", "disabled"]:
		node.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = MUTED
	focus.border_width_bottom = 1
	node.add_theme_stylebox_override("focus", focus)
	node.add_theme_color_override("font_hover_color", AMBER)
	node.add_theme_color_override("font_pressed_color", AMBER)
	node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return node

static func margin(parent: Node, inset: int = 24) -> MarginContainer:
	var node := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		node.add_theme_constant_override("margin_" + side, inset)
	parent.add_child(node)
	return node

static func scroll(parent: Node) -> VBoxContainer:
	var scroller := ScrollContainer.new()
	scroller.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroller.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroller.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(scroller)
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroller.add_child(column)
	return column

static func portrait(parent: Node, who: String) -> TextureRect:
	var node := TextureRect.new()
	node.texture = load("res://assets/portraits/%s.png" % who)
	node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(node)
	return node
