extends Node2D

const ATLASES = [preload("res://assets/personajes/sota/perfiles_pixel_v7.png"), preload("res://assets/personajes/sota/perfiles_base_v1.png")]
const METADATA = ["res://assets/personajes/sota/perfiles_pixel_v7.json", "res://assets/personajes/sota/perfiles_base_v1.json"]
const ART_LABELS = ["Referencia aprobada", "Base e iluminación"]
const BACKGROUND = preload("res://assets/entornos/velvet/fondo_suelo_recto_v1.png")
const RAILING = preload("res://assets/entornos/velvet/barandilla_v1.png")
const COUNTER = preload("res://assets/entornos/velvet/mostrador_v1.png")
const COUNTER_BACKGROUND = preload("res://assets/entornos/velvet/fondo_recepcion_reparado_v1.png")
const STAFF = preload("res://assets/personajes/jefa/perfil_mostrador_v1.png")
const EQUIPMENT = preload("res://assets/entornos/velvet/equipo_recepcion_v1.png")
const ACCESS_PERSON = preload("res://assets/entornos/velvet/figurante_acceso_v2.png")
const ACCESS_BACKGROUND = preload("res://assets/entornos/velvet/fondo_acceso_reparado_v2.png")
const ACCESS_COMPANION = preload("res://assets/entornos/velvet/acompanante_acceso_v1.png")
const ACCESS_PATCH_RECT = Rect2(1510, 414, 154, 261)
const GUARD = preload("res://assets/entornos/velvet/guardia_cabina_v1.png")
const BOOTH_FRONT = preload("res://assets/entornos/velvet/frontal_cabina_v1.png")
const BOOTH_BACKGROUND = preload("res://assets/entornos/velvet/fondo_cabina_reparado_v1.png")
const BOOTH_RECT = Rect2(151, 396, 126, 279)
const BOOTH_PATCH_RECT = Rect2(149, 389, 129, 286)
const COUNTER_RECT = Rect2(1210, 538, 278, 137)
const COUNTER_PATCH_RECT = Rect2(1210, 440, 278, 235)
const CUTOUT = preload("res://assets/personajes/sota/silueta.gdshader")
const RIM_LIGHT = preload("res://assets/personajes/sota/contraluz.gdshader")
const LABELS = ["Perfil derecho", "Perfil izquierdo"]
const HEIGHTS = [232.0, 252.0, 272.0]
const LIGHT_LABELS = ["Luz de Velvet", "Sin neón", "Azul", "Ámbar"]
const RIM_COLORS = [Color.WHITE, Color(0.18, 0.16, 0.15), Color(0.08, 0.55, 0.9), Color(0.95, 0.55, 0.12)]
const BACK_EDGE_Y = 675.0
const FRONT_EDGE_Y = 735.0
const GROUND_Y = (BACK_EDGE_Y + FRONT_EDGE_Y) / 2.0

var views: Array
var art_index := 1
var pose_index := 0
var light_index := 0
var character_height := 252.0
var ground := Vector2(780, GROUND_Y)
var sota := Sprite2D.new()
var status := Label.new()
var railing := Sprite2D.new()
var back_railing := Sprite2D.new()
var counter := Sprite2D.new()
var counter_patch := Sprite2D.new()
var staff := Sprite2D.new()
var equipment := Sprite2D.new()
var access_person := Sprite2D.new()
var access_patch := Sprite2D.new()
var access_companion := Sprite2D.new()
var guard := Sprite2D.new()
var booth_front := Sprite2D.new()
var booth_patch := Sprite2D.new()
var review_panel := PanelContainer.new()


func _ready() -> void:
	load_views()
	var background := Sprite2D.new()
	background.texture = BACKGROUND
	background.centered = false
	background.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	background.z_index = -20
	add_child(background)
	var patch_texture := AtlasTexture.new()
	patch_texture.atlas = COUNTER_BACKGROUND
	patch_texture.region = COUNTER_PATCH_RECT
	patch_texture.filter_clip = true
	counter_patch.texture = patch_texture
	counter_patch.centered = false
	counter_patch.position = COUNTER_PATCH_RECT.position
	counter_patch.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	counter_patch.z_index = -19
	add_child(counter_patch)
	var access_patch_texture := AtlasTexture.new()
	access_patch_texture.atlas = ACCESS_BACKGROUND
	access_patch_texture.region = ACCESS_PATCH_RECT
	access_patch_texture.filter_clip = true
	access_patch.texture = access_patch_texture
	access_patch.centered = false
	access_patch.position = ACCESS_PATCH_RECT.position
	access_patch.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	access_patch.z_index = -19
	add_child(access_patch)
	var booth_patch_texture := AtlasTexture.new()
	booth_patch_texture.atlas = BOOTH_BACKGROUND
	booth_patch_texture.region = BOOTH_PATCH_RECT
	booth_patch_texture.filter_clip = true
	booth_patch.texture = booth_patch_texture
	booth_patch.centered = false
	booth_patch.position = BOOTH_PATCH_RECT.position
	booth_patch.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	booth_patch.z_index = -19
	add_child(booth_patch)
	# shortcut: módulos repetidos conservan la luz del recurso; variar acabados al separar luces en T09.
	var rail_texture := AtlasTexture.new()
	rail_texture.atlas = RAILING
	rail_texture.region = Rect2(382, 506, 910, 186)
	rail_texture.filter_clip = true
	railing.texture = rail_texture
	railing.centered = false
	railing.position = Vector2(450, FRONT_EDGE_Y - 126.0)
	railing.scale = Vector2(485.0 / 910.0, 126.0 / 186.0)
	railing.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var rail_material := ShaderMaterial.new()
	rail_material.shader = preload("res://assets/entornos/velvet/metal_opaco.gdshader")
	railing.material = rail_material
	railing.z_index = 5
	add_child(railing)
	# Unir por los postes extremos, separados 754 píxeles; los remates del PNG sobresalen.
	for offset in [-2, -1, 1, 2, 3]:
		var extension := Sprite2D.new()
		extension.texture = rail_texture
		extension.centered = false
		extension.position.x = offset * 754.0
		extension.material = rail_material
		railing.add_child(extension)
	back_railing.texture = rail_texture
	back_railing.centered = false
	back_railing.position = Vector2(450, BACK_EDGE_Y - 126.0)
	back_railing.scale = railing.scale
	back_railing.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	back_railing.material = rail_material
	back_railing.z_index = -5
	add_child(back_railing)
	var staff_texture := AtlasTexture.new()
	staff_texture.atlas = STAFF
	staff_texture.region = Rect2(234, 120, 634, 1339)
	staff_texture.filter_clip = true
	staff.texture = staff_texture
	staff.centered = false
	staff.position = Vector2(1328, BACK_EDGE_Y - 244.0)
	staff.scale = Vector2.ONE * (244.0 / 1339.0)
	staff.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	# shortcut: contraluz manual de recepción; conectar fuentes espaciales en T09.
	var staff_material := ShaderMaterial.new()
	staff_material.shader = RIM_LIGHT
	staff_material.set_shader_parameter("left_color", Color(1.0, 0.42, 0.04))
	staff_material.set_shader_parameter("right_color", Color(1.0, 0.04, 0.18))
	staff.material = staff_material
	staff.z_index = -4
	add_child(staff)
	var access_texture := AtlasTexture.new()
	access_texture.atlas = ACCESS_PERSON
	access_texture.region = Rect2(323, 116, 399, 1345)
	access_texture.filter_clip = true
	access_person.texture = access_texture
	access_person.centered = false
	access_person.position = Vector2(1522, BACK_EDGE_Y - 236.0)
	access_person.scale = Vector2.ONE * (236.0 / 1345.0)
	access_person.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	access_person.material = staff_material.duplicate()
	access_person.z_index = -4
	add_child(access_person)
	var companion_texture := AtlasTexture.new()
	companion_texture.atlas = ACCESS_COMPANION
	companion_texture.region = Rect2(389, 141, 374, 1329)
	companion_texture.filter_clip = true
	access_companion.texture = companion_texture
	access_companion.centered = false
	access_companion.position = Vector2(1594, BACK_EDGE_Y - 248.0)
	access_companion.scale = Vector2.ONE * (248.0 / 1329.0)
	access_companion.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	access_companion.material = staff_material.duplicate()
	access_companion.z_index = -4
	add_child(access_companion)
	var guard_texture := AtlasTexture.new()
	guard_texture.atlas = GUARD
	guard_texture.region = Rect2(300, 107, 540, 1383)
	guard_texture.filter_clip = true
	guard.texture = guard_texture
	guard.centered = false
	guard.position = Vector2(166, BACK_EDGE_Y - 260.0)
	guard.scale = Vector2.ONE * (260.0 / 1383.0)
	guard.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	guard.material = staff_material.duplicate()
	guard.z_index = -8
	add_child(guard)
	var booth_texture := AtlasTexture.new()
	booth_texture.atlas = BOOTH_FRONT
	booth_texture.region = Rect2(80, 122, 673, 1637)
	booth_texture.filter_clip = true
	booth_front.texture = booth_texture
	booth_front.centered = false
	booth_front.position = BOOTH_RECT.position
	booth_front.scale = BOOTH_RECT.size / booth_texture.get_size()
	booth_front.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	booth_front.material = rail_material
	booth_front.z_index = -7
	add_child(booth_front)
	var counter_texture := AtlasTexture.new()
	counter_texture.atlas = COUNTER
	counter_texture.region = Rect2(575, 323, 990, 445)
	counter_texture.filter_clip = true
	counter.texture = counter_texture
	counter.centered = false
	counter.position = COUNTER_RECT.position
	counter.scale = COUNTER_RECT.size / counter_texture.get_size()
	counter.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	counter.material = rail_material
	counter.z_index = -3
	add_child(counter)
	var equipment_texture := AtlasTexture.new()
	equipment_texture.atlas = EQUIPMENT
	equipment_texture.region = Rect2(208, 121, 1374, 654)
	equipment_texture.filter_clip = true
	equipment.texture = equipment_texture
	equipment.centered = false
	equipment.position = Vector2(1218, COUNTER_RECT.position.y - 59.0)
	equipment.scale = Vector2.ONE * (59.0 / 654.0)
	equipment.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	equipment.material = rail_material
	equipment.z_index = -2
	add_child(equipment)
	sota.centered = false
	sota.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var material := ShaderMaterial.new()
	material.shader = RIM_LIGHT
	sota.material = material
	add_child(sota)
	build_controls()
	set_lighting(0)


func load_views() -> void:
	views = JSON.parse_string(FileAccess.get_file_as_string(METADATA[art_index]))["vistas"].slice(0, 2)


func set_art(index: int) -> void:
	art_index = index
	load_views()
	sota.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sota.material.shader = CUTOUT if index == 0 else RIM_LIGHT
	set_lighting(light_index)


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
	status.text = "%s · %s · Altura %d · %s · %s" % [ART_LABELS[art_index], LABELS[index], character_height, "Suave" if sota.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR else "Nítido", LIGHT_LABELS[light_index]]


func set_lighting(index: int) -> void:
	light_index = index
	if art_index == 0:
		sota.material.set_shader_parameter("recolor_rim", index != 0)
		sota.material.set_shader_parameter("pink_rim", RIM_COLORS[index])
		sota.material.set_shader_parameter("warm_rim", RIM_COLORS[index])
	else:
		sota.material.set_shader_parameter("rim_strength", 0.0 if index == 1 else 0.7)
		sota.material.set_shader_parameter("left_color", Color(1.0, 0.04, 0.18) if index == 0 else RIM_COLORS[index])
		sota.material.set_shader_parameter("right_color", Color(1.0, 0.42, 0.04) if index == 0 else RIM_COLORS[index])
	show_pose(pose_index)


func set_height(value: float) -> void:
	character_height = value
	show_pose(pose_index)


func set_ground(x: float) -> void:
	ground.x = x
	# Despejar la cabina al revisar el extremo izquierdo.
	review_panel.position.x = 480.0 if x <= 340.0 else 24.0
	show_pose(pose_index)


func toggle_filter() -> void:
	sota.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST if sota.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR else CanvasItem.TEXTURE_FILTER_LINEAR
	show_pose(pose_index)


func set_railings(back_visible: bool, front_visible: bool) -> void:
	back_railing.visible = back_visible
	railing.visible = front_visible


func build_controls() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := review_panel
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
	title.text = "VELVET · Figuración por capas"
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
	add_button(options, "Personal", set_ground.bind(160.0))
	add_button(options, "Extremo", set_ground.bind(1500.0))
	add_button(options, "Suave / nítido", toggle_filter)
	var lighting := HBoxContainer.new()
	column.add_child(lighting)
	for index in range(LIGHT_LABELS.size()):
		add_button(lighting, LIGHT_LABELS[index], set_lighting.bind(index))
	var depths := HBoxContainer.new()
	column.add_child(depths)
	add_button(depths, "Ambas barandillas", set_railings.bind(true, true))
	add_button(depths, "Solo trasera", set_railings.bind(true, false))
	add_button(depths, "Solo delantera", set_railings.bind(false, true))
	add_button(depths, "Sin barandillas", set_railings.bind(false, false))
	var reception := HBoxContainer.new()
	column.add_child(reception)
	add_button(reception, "Mostrador visible", counter.show)
	add_button(reception, "Ocultar mostrador", counter.hide)
	add_button(reception, "Frente al mostrador", set_ground.bind(1345.0))
	var actors := HBoxContainer.new()
	column.add_child(actors)
	for entry in [["Jefa", staff], ["Equipo", equipment], ["Acceso", access_person]]:
		var toggle := CheckButton.new()
		toggle.text = entry[0]
		toggle.button_pressed = true
		toggle.toggled.connect(entry[1].set_visible)
		actors.add_child(toggle)
	add_button(actors, "Junto al acceso", set_ground.bind(1560.0))
	var companions := HBoxContainer.new()
	column.add_child(companions)
	var companion_toggle := CheckButton.new()
	companion_toggle.text = "Acompañante"
	companion_toggle.button_pressed = true
	companion_toggle.toggled.connect(access_companion.set_visible)
	companions.add_child(companion_toggle)
	add_button(companions, "Junto al acompañante", set_ground.bind(1625.0))
	var booth := HBoxContainer.new()
	column.add_child(booth)
	for entry in [["Guardia", guard], ["Cabina", booth_front]]:
		var toggle := CheckButton.new()
		toggle.text = entry[0]
		toggle.button_pressed = true
		toggle.toggled.connect(entry[1].set_visible)
		booth.add_child(toggle)
	add_button(booth, "Frente al guardia", set_ground.bind(300.0))
	column.add_child(status)
	poses.get_child(0).grab_focus()


func add_button(row: HBoxContainer, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 38
	button.pressed.connect(action)
	row.add_child(button)
