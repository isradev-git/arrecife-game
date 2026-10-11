extends SceneTree

const SCENE = preload("res://revision_escala.gd")

var viewport := SubViewport.new()

func _initialize() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("Esta prueba necesita renderizado gráfico; ejecutar sin --headless.")
		quit(1)
		return
	call_deferred("check")

func frame() -> Image:
	for index in range(4):
		await process_frame
	await RenderingServer.frame_post_draw
	return viewport.get_texture().get_image()

func check() -> void:
	viewport.size = Vector2i(1536, 1024)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var sprite := Sprite2D.new()
	sprite.centered = false
	sprite.texture = SCENE.ATLASES[1]
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var material := ShaderMaterial.new()
	material.shader = SCENE.CUTOUT
	sprite.material = material
	viewport.add_child(sprite)
	var baseline: Image = await frame()
	var opaque := 0
	for y in baseline.get_height():
		for x in baseline.get_width():
			if baseline.get_pixel(x, y).a > 0.1:
				opaque += 1
	var colors: Array = SCENE.RIM_COLORS.slice(1)
	for color in colors:
		material.set_shader_parameter("recolor_rim", true)
		material.set_shader_parameter("pink_rim", color)
		material.set_shader_parameter("warm_rim", color)
		var rendered: Image = await frame()
		var changed := 0
		var pink := 0
		for y in rendered.get_height():
			for x in rendered.get_width():
				var before := baseline.get_pixel(x, y)
				var after := rendered.get_pixel(x, y)
				assert(is_equal_approx(before.a, after.a))
				if before != after and before.a > 0.1:
					changed += 1
				if after.a > 0.1 and after.r > 0.6 and after.b > after.g + 0.08 and after.r > after.b * 1.2:
					pink += 1
		assert(changed > opaque * 0.005 and changed < opaque * 0.1)
		assert(pink == 0)
		for point in [Vector2i(430, 300), Vector2i(528, 185), Vector2i(525, 168), Vector2i(480, 430), Vector2i(480, 600), Vector2i(1005, 168)]:
			assert(baseline.get_pixelv(point).a > 0.1)
			assert(baseline.get_pixelv(point) == rendered.get_pixelv(point))
		print("OK: ", changed, " píxeles de contorno modificados; alfa y muestras de cara, ojos, ropa y equipo conservados; rosa intenso restante: ", pink)
	material.set_shader_parameter("recolor_rim", false)
	var restored: Image = await frame()
	assert(baseline.get_data() == restored.get_data())
	print("OK: restauración idéntica del aspecto original.")
	quit()
