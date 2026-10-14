extends SceneTree

# Prueba aislada de anatomía. No modifica el atlas ni el recorrido activos.
const RIG = preload("res://sota_articulada.gd")
const V7 = preload("res://assets/personajes/sota/perfiles_pixel_v7.png")
const CUTOUT = preload("res://assets/personajes/sota/silueta.gdshader")
const OUTPUT = "res://../trabajo/arte/revisiones/claves_sota_v71/"
const CELL = Vector2i(256, 320)
const ROOT = Vector2(128, 300)
const PHASES = [0.0, 0.25, 0.5, 0.75]
const NAMES = ["contacto", "apoyo", "impulso", "avance"]
const SOURCE_ANCHOR = Vector2(535, 1410)
const SOURCE_SCALE = 0.185

var cloth: Texture2D
var cloth_material: ShaderMaterial

func _initialize() -> void:
	call_deferred("prepare")

func prepare() -> void:
	assert(DisplayServer.get_name() != "headless", "La vista necesita GPU")
	var source := Image.load_from_file(ProjectSettings.globalize_path(OUTPUT + "base_anatomica_intento1.png"))
	assert(not source.is_empty())
	cloth = ImageTexture.create_from_image(source)
	cloth_material = ShaderMaterial.new()
	cloth_material.shader = CUTOUT
	cloth_material.set_shader_parameter("alpha_threshold", 0.95)
	cloth_material.set_shader_parameter("opaque_cutout", true)
	for index in range(PHASES.size()):
		var viewport := SubViewport.new()
		viewport.size = CELL
		viewport.transparent_bg = true
		viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		root.add_child(viewport)
		var figure = RIG.new()
		viewport.add_child(figure)
		figure.build(0)
		figure.position = ROOT
		figure.pose(PHASES[index])
		add_anatomy(figure)
		for n in range(3): await process_frame
		await RenderingServer.frame_post_draw
		var png := viewport.get_texture().get_image()
		assert(png.save_png(OUTPUT + NAMES[index] + ".png") == OK)
		viewport.queue_free()
		await process_frame
	await render_reference()
	compose_comparison()
	print("OK: cuatro claves anatómicas provisionales, marco 256x320, raíz (128,300), cinemática v4 sin tocar recorrido")
	quit()

func render_reference() -> void:
	var viewport := SubViewport.new()
	viewport.size = CELL
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var sprite := Sprite2D.new()
	sprite.texture = V7
	sprite.centered = false
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2.ONE * (252.0 / 869.0)
	sprite.position = ROOT - Vector2(493.5, 945) * sprite.scale
	var material := ShaderMaterial.new()
	material.shader = CUTOUT
	material.set_shader_parameter("alpha_threshold", 0.95)
	material.set_shader_parameter("opaque_cutout", true)
	sprite.material = material
	viewport.add_child(sprite)
	for n in range(3): await process_frame
	await RenderingServer.frame_post_draw
	assert(viewport.get_texture().get_image().save_png(OUTPUT + "v7_reposo_derecha.png") == OK)
	viewport.queue_free()
	await process_frame

func compose_comparison() -> void:
	var names := ["v7_reposo_derecha", "contacto", "apoyo", "impulso", "avance"]
	var board := Image.create_empty(CELL.x * names.size(), CELL.y, false, Image.FORMAT_RGBA8)
	board.fill(Color8(23, 22, 27))
	for index in range(names.size()):
		var frame := Image.load_from_file(ProjectSettings.globalize_path(OUTPUT + names[index] + ".png"))
		board.blend_rect(frame, Rect2i(Vector2i.ZERO, CELL), Vector2i(index * CELL.x, 0))
	assert(board.save_png(OUTPUT + "comparacion_v7_claves.png") == OK)
	board.resize(board.get_width() * 2, board.get_height() * 2, Image.INTERPOLATE_NEAREST)
	assert(board.save_png(OUTPUT + "comparacion_v7_claves_2x.png") == OK)

func polygon(values: Array, color: Color, depth: int, parent: Node2D) -> Polygon2D:
	var node := Polygon2D.new()
	var points := PackedVector2Array()
	for value in values: points.append(value)
	node.polygon = points
	node.color = color
	node.z_index = depth
	parent.add_child(node)
	return node

func textured(outline: Array, mapper: Callable, depth: int, parent: Node2D) -> void:
	var source_outline := PackedVector2Array()
	for value in outline: source_outline.append(value)
	var node := Polygon2D.new()
	var mapped := PackedVector2Array()
	for point in source_outline: mapped.append(mapper.call(point))
	node.polygon = mapped
	node.uv = source_outline
	node.texture = cloth
	node.material = cloth_material
	node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	node.z_index = depth
	parent.add_child(node)

func source_to_local(point: Vector2) -> Vector2:
	return (point - SOURCE_ANCHOR) * SOURCE_SCALE

func limb_map(point: Vector2, start_source: Vector2, end_source: Vector2, start_target: Vector2, end_target: Vector2) -> Vector2:
	var source_axis := end_source - start_source
	var source_unit := source_axis.normalized()
	var source_normal := Vector2(-source_unit.y, source_unit.x)
	var target_axis := end_target - start_target
	var target_normal := Vector2(-target_axis.y, target_axis.x).normalized()
	var relative := point - start_source
	return start_target + target_axis * (relative.dot(source_unit) / source_axis.length()) + target_normal * relative.dot(source_normal) * SOURCE_SCALE

func leg_shape(hip: Vector2, knee: Vector2, ankle: Vector2, depth: int, parent: Node2D) -> void:
	var dark := Color8(12, 12, 11)
	var olive := Color8(54, 55, 47)
	var left := Vector2(-1, 0)
	var right := Vector2(1, 0)
	var outline := [hip + left*13, hip + right*13, knee + right*12, ankle + right*11, ankle + left*11, knee + left*12]
	polygon(outline, dark, depth, parent)
	var inner := [hip + left*11, hip + right*11, knee + right*10, ankle + right*9, ankle + left*9, knee + left*10]
	polygon(inner, olive, depth + 1, parent)

func add_anatomy(figure: Node2D) -> void:
	var far: Dictionary = figure.legs[0]
	var near: Dictionary = figure.legs[1]
	for leg in [far, near]:
		leg.thigh.hide()
		leg.shin.hide()
		# La bota v7 conserva su propia forma y suela.
	var parent: Node2D = figure.body
	var pelvis := [Vector2(-25,-146), Vector2(14,-146), Vector2(20,-130), Vector2(13,-110), Vector2(-12,-105), Vector2(-23,-116), Vector2(-28,-128)]
	polygon(pelvis, Color8(10,10,9), -1, parent)
	var inner_pelvis := [Vector2(-23,-143), Vector2(12,-143), Vector2(17,-130), Vector2(11,-112), Vector2(-11,-108), Vector2(-21,-117), Vector2(-25,-128)]
	polygon(inner_pelvis, Color8(55,56,48), 0, parent)
	textured([Vector2(385,670),Vector2(614,670),Vector2(616,805),Vector2(579,848),Vector2(413,848),Vector2(383,797)], source_to_local, 1, parent)
	for index in range(2):
		var leg: Dictionary = figure.legs[index]
		var hip: Vector2 = leg.thigh.position + Vector2(-7 if index == 0 else 2, 0)
		var knee: Vector2 = leg.shin.position
		var ankle: Vector2 = leg.boot.position
		var cuff := ankle + Vector2(0, -22)
		var depth := -4 if index == 0 else 1
		leg_shape(hip, knee, cuff, depth, parent)
		var hip_source := Vector2(425,780) if index == 0 else Vector2(555,780)
		var knee_source := Vector2(353,994) if index == 0 else Vector2(625,993)
		var ankle_source := Vector2(350,1191) if index == 0 else Vector2(630,1192)
		var upper := [Vector2(390,760),Vector2(499,755),Vector2(491,1004),Vector2(306,1009)] if index == 0 else [Vector2(490,754),Vector2(646,754),Vector2(702,1010),Vector2(493,1010)]
		var lower := [Vector2(303,983),Vector2(490,983),Vector2(470,1195),Vector2(257,1195)] if index == 0 else [Vector2(497,981),Vector2(704,981),Vector2(728,1195),Vector2(542,1195)]
		textured(upper, limb_map.bind(hip_source,knee_source,hip,knee), depth+1, parent)
		textured(lower, limb_map.bind(knee_source,ankle_source,knee,cuff), depth+1, parent)
