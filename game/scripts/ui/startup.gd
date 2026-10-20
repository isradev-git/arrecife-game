extends Control

signal finished

var orientation_only := false
var stage := 0
var mobile := OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")
var timer := Timer.new()
var canvas := Control.new()
var phone_tween: Tween

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
		0:
			headline = Content.story.startup.logo
			body = Content.story.startup.tagline
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
		var button := GameUI.button(column, "Entrar al juego" if stage == 2 else "Continuar", advance)
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		button.custom_minimum_size.x = 200
		timer.start(3.0 if stage == 2 else 2.4)
	elif stage == 2 and is_portrait_mobile():
		GameUI.label(column, Content.story.startup.rotate_hint, 19).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if not orientation_only and not State.settings.reduced_motion:
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
