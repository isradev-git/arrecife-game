extends Node2D

const ATLASES = [preload("res://assets/personajes/sota/perfiles_pixel_v3.png"), preload("res://assets/personajes/sota/perfiles_pixel_v7.png")]
const METADATA = ["res://assets/personajes/sota/perfiles_pixel_v3.json", "res://assets/personajes/sota/perfiles_pixel_v7.json"]
const ART_LABELS = ["Antes del retoque", "Ojos sutiles"]
const BACKGROUND = preload("res://assets/fiebre_velvet_pixel_v1.png")
const CUTOUT = preload("res://assets/personajes/sota/silueta.gdshader")
const LABELS = ["Perfil derecho", "Perfil izquierdo"]
const HEIGHTS = [232.0, 252.0, 272.0]

var views: Array
var art_index := 1
var pose_index := 0
var character_height := 252.0
var ground := Vector2(780, 710)
var sota := Sprite2D.new()
var status := Label.new()


func _ready() -> void:
	load_views()
	var background := Sprite2D.new()
	background.texture = BACKGROUND
	background.centered = false
	background.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(background)
	sota.centered = false
	sota.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var material := ShaderMaterial.new()
	material.shader = CUTOUT
	sota.material = material
	add_child(sota)
	build_controls()
	show_pose(0)


func load_views() -> void:
	views = JSON.parse_string(FileAccess.get_file_as_string(METADATA[art_index]))["vistas"].slice(0, 2)


func set_art(index: int) -> void:
	art_index = index
	load_views()
	sota.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	show_pose(pose_index)


func show_pose(index: int) -> void:
	pose_index = index
	var view: Dictionary = views[index]
	var cell: Array = view["region"]
	var bounds: Array = view["limites_alfa_10_por_ciento"]
	var texture := AtlasTexture.new()
	texture.atlas = ATLASES[art_index]
	texture.region = Rect2(cell[0] + bounds[0], cell[1] + bounds[1], bounds[2], bounds[3])
	texture.filter_clip = true
	sota.texture = texture
	var ratio: float = character_height / float(bounds[3])
	sota.scale = Vector2(ratio, ratio)
	sota.offset = Vector2(-float(bounds[2]) / 2.0, -float(bounds[3]))
	sota.position = ground
	status.text = "%s · %s · Altura %d · %s" % [ART_LABELS[art_index], LABELS[index], character_height, "Suave" if sota.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR else "Nítido"]


func set_height(value: float) -> void:
	character_height = value
	show_pose(pose_index)


func set_ground(x: float) -> void:
	ground.x = x
	show_pose(pose_index)


func toggle_filter() -> void:
	sota.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST if sota.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR else CanvasItem.TEXTURE_FILTER_LINEAR
	show_pose(pose_index)


func build_controls() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := PanelContainer.new()
	panel.position = Vector2(24, 24)
	layer.add_child(panel)
	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 14)
	panel.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	margin.add_child(column)
	var title := Label.new()
	title.text = "VELVET · Revisión de Sota"
	title.add_theme_font_size_override("font_size", 24)
	column.add_child(title)
	var art := HBoxContainer.new()
	column.add_child(art)
	for index in range(ART_LABELS.size()):
		add_button(art, ART_LABELS[index], set_art.bind(index))
	var poses := HBoxContainer.new()
	column.add_child(poses)
	for index in range(LABELS.size()):
		add_button(poses, LABELS[index], show_pose.bind(index))
	var options := HBoxContainer.new()
	column.add_child(options)
	for height in HEIGHTS:
		add_button(options, str(int(height)), set_height.bind(height))
	add_button(options, "Galería", set_ground.bind(780.0))
	add_button(options, "Recepción", set_ground.bind(1160.0))
	add_button(options, "Suave / nítido", toggle_filter)
	column.add_child(status)
	poses.get_child(0).grab_focus()


func add_button(row: HBoxContainer, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 38
	button.pressed.connect(action)
	row.add_child(button)
