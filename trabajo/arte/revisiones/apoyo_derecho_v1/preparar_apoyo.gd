extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/apoyo_derecho_v1/"
const INPUT = DIR + "referencia_ia_intento2.png"
const REFERENCE = "res://../trabajo/arte/revisiones/contacto_derecha_diagnostico_v1/contacto_derecha_prueba_v2.png"
const OUTPUT = DIR + "apoyo_derecho_prueba_v1.png"
const ZOOM = DIR + "apoyo_derecho_prueba_v1_4x.png"
const COMPARISON = DIR + "comparacion_contacto_apoyo_v1.png"

func _initialize() -> void:
	var source := Image.load_from_file(ProjectSettings.globalize_path(INPUT))
	assert(source.get_size() == Vector2i(1122, 1402))
	var figure := source.get_region(Rect2i(392, 238, 398, 1056))
	figure.resize(90, 254, Image.INTERPOLATE_NEAREST)
	var reference := Image.load_from_file(ProjectSettings.globalize_path(REFERENCE))
	assert(reference.get_size() == Vector2i(256, 320))
	var palette: Array[Color] = []
	var seen := {}
	for y in range(174, 300):
		for x in range(256):
			var color := reference.get_pixel(x, y)
			if color.a < 0.95: continue
			var key := color.to_rgba32()
			if not seen.has(key):
				seen[key] = true
				palette.append(color)
	var frame := Image.create_empty(256, 320, false, Image.FORMAT_RGBA8)
	frame.fill(Color(0, 0, 0, 0))
	var mapped := {}
	for y in range(figure.get_height()):
		for x in range(figure.get_width()):
			var pixel := figure.get_pixel(x, y)
			if pixel.a < 0.95: continue
			var key := pixel.to_rgba32()
			if not mapped.has(key):
				var best := palette[0]
				var distance := INF
				for sample in palette:
					var delta := pixel - sample
					var score := delta.r * delta.r + delta.g * delta.g + delta.b * delta.b
					if score < distance:
						distance = score
						best = sample
				mapped[key] = Color(best.r, best.g, best.b, 1.0)
			frame.set_pixel(84 + x, 46 + y, mapped[key])
	frame.blit_rect(reference, Rect2i(0, 2, 256, 174), Vector2i.ZERO)
	for y in range(176, 211):
		for x in range(95, 117):
			# La mano del contacto queda delante; ningún bolsillo se copia de la otra pierna.
			var pixel := reference.get_pixel(x, y)
			if pixel.a >= 0.95:
				frame.set_pixel(x, y - 2, pixel)
	# shortcut: desplazar cada pierna bajo la rodilla sin estrechar la bota; redibujar el pliegue si se ve forzado.
	for y in range(235, 300):
		var far := []
		var near := []
		for x in range(70, 180):
			var pixel := frame.get_pixel(x, y)
			if pixel.a < 0.95: continue
			if x < 125: far.append([x, pixel])
			else: near.append([x, pixel])
			frame.set_pixel(x, y, Color(0, 0, 0, 0))
		var amount := clampf((y - 235.0) / 60.0, 0.0, 1.0)
		for item in far:
			frame.set_pixel(item[0] + roundi(6.0 * amount), y, item[1])
		for item in near:
			frame.set_pixel(item[0] - roundi(22.0 * amount), y, item[1])
	var bounds := Rect2i(256, 320, 0, 0)
	for y in range(320):
		for x in range(256):
			var pixel := frame.get_pixel(x, y)
			assert(pixel.a == 0.0 or pixel.a == 1.0)
			if y < 174: assert(pixel == reference.get_pixel(x, y + 2))
			if pixel.a == 1.0:
				bounds.position.x = mini(bounds.position.x, x)
				bounds.position.y = mini(bounds.position.y, y)
				bounds.end.x = maxi(bounds.end.x, x + 1)
				bounds.end.y = maxi(bounds.end.y, y + 1)
	assert(bounds == Rect2i(87, 46, 65, 254))
	assert(frame.get_pixel(128, 286).a == 1.0 and frame.get_pixel(150, 293).a == 1.0)
	assert(frame.save_png(ProjectSettings.globalize_path(OUTPUT)) == OK)
	var comparison := Image.create_empty(512, 320, false, Image.FORMAT_RGBA8)
	comparison.fill(Color8(23, 22, 27))
	comparison.blend_rect(reference, Rect2i(0, 0, 256, 320), Vector2i.ZERO)
	comparison.blend_rect(frame, Rect2i(0, 0, 256, 320), Vector2i(256, 0))
	assert(comparison.save_png(ProjectSettings.globalize_path(COMPARISON)) == OK)
	var enlarged := frame.duplicate()
	enlarged.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(enlarged.save_png(ProjectSettings.globalize_path(ZOOM)) == OK)
	quit()
