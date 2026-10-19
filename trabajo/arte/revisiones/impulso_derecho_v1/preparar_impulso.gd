extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/impulso_derecho_v1/"
const INPUT = DIR + "referencia_ia_intento4.png"
const CONTACT = "res://../trabajo/arte/revisiones/contacto_derecha_diagnostico_v1/contacto_derecha_prueba_v2.png"
const SUPPORT = "res://../trabajo/arte/revisiones/apoyo_derecho_v1/apoyo_derecho_prueba_v1.png"

func _initialize() -> void:
	var source := Image.load_from_file(ProjectSettings.globalize_path(INPUT))
	assert(source.get_size() == Vector2i(1122, 1402))
	var figure := source.get_region(Rect2i(347, 227, 481, 1060))
	figure.resize(115, 252, Image.INTERPOLATE_NEAREST)
	var contact := Image.load_from_file(ProjectSettings.globalize_path(CONTACT))
	var support := Image.load_from_file(ProjectSettings.globalize_path(SUPPORT))
	assert(contact.get_size() == Vector2i(256, 320) and support.get_size() == Vector2i(256, 320))
	var palette: Array[Color] = []
	var seen := {}
	for y in range(176, 300):
		for x in range(256):
			var color := contact.get_pixel(x, y)
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
			var target := Vector2i(72 + x, 48 + y)
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
			frame.set_pixelv(target, mapped[key])
	frame.blit_rect(contact, Rect2i(0, 0, 256, 176), Vector2i.ZERO)
	for y in range(176, 211):
		for x in range(95, 117):
			var pixel := contact.get_pixel(x, y)
			if pixel.a == 1.0: frame.set_pixel(x, y, pixel)
	var bounds := Rect2i(256, 320, 0, 0)
	for y in range(320):
		for x in range(256):
			var pixel := frame.get_pixel(x, y)
			assert(pixel.a == 0.0 or pixel.a == 1.0)
			if y < 176: assert(pixel == contact.get_pixel(x, y))
			if pixel.a == 1.0:
				bounds.position.x = mini(bounds.position.x, x)
				bounds.position.y = mini(bounds.position.y, y)
				bounds.end.x = maxi(bounds.end.x, x + 1)
				bounds.end.y = maxi(bounds.end.y, y + 1)
	assert(bounds.position.x >= 70 and bounds.end.x <= 190 and bounds.position.y == 48 and bounds.end.y == 300)
	var left_toe := -1
	var right_toe := -1
	for y in range(288, 300):
		for x in range(70, 190):
			if frame.get_pixel(x, y).a != 1.0: continue
			if x < 130: left_toe = maxi(left_toe, x)
			elif x > 155: right_toe = maxi(right_toe, x)
	print("toe x: ", left_toe, ", ", right_toe)
	assert(absi(left_toe - 120) <= 4 and absi(right_toe - 184) <= 4)
	assert(frame.save_png(ProjectSettings.globalize_path(DIR + "impulso_derecho_prueba_v1.png")) == OK)
	var zoom := frame.duplicate()
	zoom.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(zoom.save_png(ProjectSettings.globalize_path(DIR + "impulso_derecho_prueba_v1_4x.png")) == OK)
	var comparison := Image.create_empty(768, 320, false, Image.FORMAT_RGBA8)
	comparison.fill(Color8(23, 22, 27))
	comparison.blend_rect(contact, Rect2i(0, 0, 256, 320), Vector2i.ZERO)
	comparison.blend_rect(support, Rect2i(0, 0, 256, 320), Vector2i(256, 0))
	comparison.blend_rect(frame, Rect2i(0, 0, 256, 320), Vector2i(512, 0))
	assert(comparison.save_png(ProjectSettings.globalize_path(DIR + "comparacion_tres_claves_v1.png")) == OK)
	print("bounds ", bounds)
	quit()
