extends Control

signal finished

var orientation_only := false
var stage := 0
var mobile := OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")
var timer := Timer.new()
var canvas := Control.new()
var phone_tween: Tween
var last_tap_ms := 0

func _input(event: InputEvent) -> void:
	if orientation_only or not is_visible_in_tree():
		return
	var tapped: bool = (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or (event is InputEventScreenTouch and event.pressed)
	var confirmed: bool = event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]
	if (tapped or confirmed) and Time.get_ticks_msec() - last_tap_ms > 180:
		last_tap_ms = Time.get_ticks_msec()
		advance()
		get_viewport().set_input_as_handled()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(canvas)
	GameUI.fill(canvas)
	timer.one_shot = true
	timer.timeout.connect(advance)
	add_child(timer)
	if orientation_only:
		stage = 2
		refresh()
	else:
		show_stage()

func is_portrait_mobile() -> bool:
	return mobile and get_window().size.x < get_window().size.y

func refresh() -> void:
	if orientation_only:
		visible = is_portrait_mobile()
		if visible:
			show_stage()
		elif phone_tween and phone_tween.is_running():
			phone_tween.kill()
	else:
		show_stage()

func advance() -> void:
	if stage == 2 and is_portrait_mobile():
		return
	stage += 1
	if stage == 3:
		hide()
		finished.emit()
	else:
		show_stage()

func show_stage() -> void:
	timer.stop()
	if phone_tween and phone_tween.is_running():
		phone_tween.kill()
	GameUI.clear(canvas)
	if stage == 0:
		show_logo_screen()
		return
	var backdrop := ColorRect.new()
	backdrop.color = Color("0c171d")
	canvas.add_child(backdrop)
	GameUI.fill(backdrop)
	var border := ColorRect.new()
	border.color = GameUI.AMBER
	border.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	border.custom_minimum_size.y = 3
	canvas.add_child(border)
	var center := CenterContainer.new()
	canvas.add_child(center)
	GameUI.fill(center)
	var column := VBoxContainer.new()
	column.custom_minimum_size.x = minf(get_window().content_scale_size.x - 48, 650)
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(column)
	var headline := ""
	var body := ""
	match stage:
		1:
			headline = Content.story.startup.creator
			body = Content.story.startup.rights
		2:
			headline = Content.story.startup.mobile_title if mobile else Content.story.startup.desktop_title
			body = Content.story.startup.mobile_text if mobile else Content.story.startup.desktop_text
	if stage == 2 and mobile:
		var icon := phone_icon(column)
		if not State.settings.reduced_motion:
			phone_tween = create_tween().set_loops()
			phone_tween.tween_property(icon, "rotation_degrees", 90.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			phone_tween.tween_interval(0.65)
			phone_tween.tween_property(icon, "rotation_degrees", 0.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			phone_tween.tween_interval(0.65)
	var heading := GameUI.label(column, headline, 54 if stage == 0 else 35)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.modulate = GameUI.AMBER if stage == 0 else GameUI.PAPER
	var description := GameUI.label(column, body, 22)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.modulate = GameUI.MUTED
	if not orientation_only and not (stage == 2 and is_portrait_mobile()):
		var hint := GameUI.label(canvas, "Toca la pantalla para continuar" if mobile else "Haz clic o pulsa Intro para continuar", 18)
		hint.anchor_left = 0
		hint.anchor_right = 1
		hint.anchor_top = 1
		hint.anchor_bottom = 1
		hint.offset_top = -62
		hint.offset_bottom = -20
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hint.modulate = GameUI.MUTED
		timer.start(3.0 if stage == 2 else 2.4)
	elif stage == 2 and is_portrait_mobile():
		GameUI.label(column, Content.story.startup.rotate_hint, 19).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if not orientation_only and not State.settings.reduced_motion:
		canvas.modulate.a = 0.0
		create_tween().tween_property(canvas, "modulate:a", 1.0, 0.3)

func show_logo_screen() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color("ccb8b5")
	canvas.add_child(backdrop)
	GameUI.fill(backdrop)
	var logo := TextureRect.new()
	logo.texture = load("res://assets/branding/el_arrecife_products.png")
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED if get_window().size.x < get_window().size.y else TextureRect.STRETCH_KEEP_ASPECT_COVERED
	logo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(logo)
	GameUI.fill(logo)
	var bottom := Label.new()
	bottom.text = "Toca la pantalla para continuar" if mobile else "Haz clic o pulsa Intro para continuar"
	bottom.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bottom.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	bottom.add_theme_font_size_override("font_size", 19 if mobile else 17)
	bottom.add_theme_color_override("font_color", Color("8f2525"))
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bottom.anchor_left = 0
	bottom.anchor_right = 1
	bottom.anchor_top = 1
	bottom.anchor_bottom = 1
	bottom.offset_top = -82
	bottom.offset_bottom = -16
	canvas.add_child(bottom)
	timer.start(2.4)
	if not State.settings.reduced_motion:
		canvas.modulate.a = 0.0
		create_tween().tween_property(canvas, "modulate:a", 1.0, 0.3)

func phone_icon(parent: Control) -> Control:
	var holder := CenterContainer.new()
	holder.custom_minimum_size.y = 105
	parent.add_child(holder)
	var phone := Panel.new()
	phone.custom_minimum_size = Vector2(43, 72)
	phone.pivot_offset = Vector2(21.5, 36)
	phone.add_theme_stylebox_override("panel", GameUI.box(Color("172a30"), GameUI.AMBER, 8))
	holder.add_child(phone)
	var screen := ColorRect.new()
	screen.color = Color("527069")
	screen.position = Vector2(7, 13)
	screen.size = Vector2(29, 46)
	phone.add_child(screen)
	return phone
