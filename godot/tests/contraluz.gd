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
	material.shader = SCENE.RIM_LIGHT
	material.set_shader_parameter("rim_strength", 0.0)
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
		material.set_shader_parameter("rim_strength", 0.7)
		material.set_shader_parameter("left_color", color)
		material.set_shader_parameter("right_color", color)
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
		assert(changed > opaque * 0.005 and changed < opaque * 0.15)
		assert(pink == 0)
		for point in [Vector2i(430, 300), Vector2i(528, 185), Vector2i(525, 168), Vector2i(480, 430), Vector2i(480, 600), Vector2i(1005, 168)]:
			assert(baseline.get_pixelv(point).a > 0.1)
			assert(baseline.get_pixelv(point) == rendered.get_pixelv(point))
		print("OK: ", changed, " píxeles iluminados; alfa y muestras interiores conservados; rosa fijo restante: ", pink)
	material.set_shader_parameter("rim_strength", 0.0)
	var restored: Image = await frame()
	assert(baseline.get_data() == restored.get_data())
	print("OK: intensidad cero restaura exactamente la base sin neón.")
	material.set_shader_parameter("rim_strength", 0.7)
	material.set_shader_parameter("left_color", Color(1.0, 0.0, 0.0))
	material.set_shader_parameter("right_color", Color(0.0, 0.0, 0.0, 0.0))
	var centroids := []
	for direction in [Vector2(-1.0, 0.0), Vector2(1.0, 0.0)]:
		material.set_shader_parameter("left_direction", direction)
		var directed: Image = await frame()
		var sums := [0.0, 0.0]
		var counts := [0, 0]
		for y in directed.get_height():
			for x in directed.get_width():
				if baseline.get_pixel(x, y) != directed.get_pixel(x, y):
					var cell: int = x / (directed.get_width() / 2)
					sums[cell] += x
					counts[cell] += 1
		assert(counts[0] > 0 and counts[1] > 0)
		centroids.append([sums[0] / counts[0], sums[1] / counts[1]])
	for cell in range(2):
		assert(centroids[0][cell] + 15.0 < centroids[1][cell])
	print("OK: invertir la dirección desplaza la luz al lado opuesto en ambos perfiles: ", centroids)
	quit()
