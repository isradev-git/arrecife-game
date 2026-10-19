extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/avance_derecho_v1/"
const INPUT = DIR + "referencia_ia_intento4.png"
const CONTACT = "res://../trabajo/arte/revisiones/contacto_derecha_diagnostico_v1/contacto_derecha_prueba_v2.png"
const SUPPORT = "res://../trabajo/arte/revisiones/apoyo_derecho_v1/apoyo_derecho_prueba_v1.png"
const IMPULSE = "res://../trabajo/arte/revisiones/impulso_derecho_v1/impulso_derecho_prueba_v1.png"

func _initialize() -> void:
	var source := Image.load_from_file(ProjectSettings.globalize_path(INPUT))
	assert(source.get_size() == Vector2i(1122, 1402))
	var figure := source.get_region(Rect2i(389, 198, 374, 1084))
	figure.resize(88, 254, Image.INTERPOLATE_NEAREST)
	var contact := Image.load_from_file(ProjectSettings.globalize_path(CONTACT))
	var support := Image.load_from_file(ProjectSettings.globalize_path(SUPPORT))
	var impulse := Image.load_from_file(ProjectSettings.globalize_path(IMPULSE))
	assert(contact.get_size() == Vector2i(256, 320) and support.get_size() == Vector2i(256, 320) and impulse.get_size() == Vector2i(256, 320))
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
			var target := Vector2i(80 + x, 46 + y)
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
	frame.blit_rect(support, Rect2i(0, 0, 256, 174), Vector2i.ZERO)
	for y in range(176, 211):
		for x in range(95, 117):
			var pixel := contact.get_pixel(x, y)
			if pixel.a == 1.0: frame.set_pixel(x, y - 2, pixel)
	var bounds := Rect2i(256, 320, 0, 0)
	for y in range(320):
		for x in range(256):
			var pixel := frame.get_pixel(x, y)
			assert(pixel.a == 0.0 or pixel.a == 1.0)
			if y < 174: assert(pixel == support.get_pixel(x, y))
			if pixel.a == 1.0:
				bounds.position.x = mini(bounds.position.x, x)
				bounds.position.y = mini(bounds.position.y, y)
				bounds.end.x = maxi(bounds.end.x, x + 1)
				bounds.end.y = maxi(bounds.end.y, y + 1)
	assert(bounds.position.x >= 75 and bounds.end.x <= 175 and bounds.position.y == 46 and bounds.end.y == 300)
	assert(frame.save_png(ProjectSettings.globalize_path(DIR + "avance_derecho_diagnostico_v1.png")) == OK)
	var zoom := frame.duplicate()
	zoom.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(zoom.save_png(ProjectSettings.globalize_path(DIR + "avance_derecho_diagnostico_v1_4x.png")) == OK)
	var comparison := Image.create_empty(1024, 320, false, Image.FORMAT_RGBA8)
	comparison.fill(Color8(23, 22, 27))
	comparison.blend_rect(contact, Rect2i(0, 0, 256, 320), Vector2i.ZERO)
	comparison.blend_rect(support, Rect2i(0, 0, 256, 320), Vector2i(256, 0))
	comparison.blend_rect(impulse, Rect2i(0, 0, 256, 320), Vector2i(512, 0))
	comparison.blend_rect(frame, Rect2i(0, 0, 256, 320), Vector2i(768, 0))
	assert(comparison.save_png(ProjectSettings.globalize_path(DIR + "comparacion_cuatro_claves_diagnostico_v1.png")) == OK)
	var guide := frame.duplicate()
	for dx in range(-4, 5):
		guide.set_pixel(128 + dx, 280, Color8(0, 229, 255))
		guide.set_pixel(152 + dx, 298, Color8(255, 251, 0))
	for dy in range(-4, 5):
		guide.set_pixel(128, 280 + dy, Color8(0, 229, 255))
		guide.set_pixel(152, 298 + dy, Color8(255, 251, 0))
	guide.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(guide.save_png(ProjectSettings.globalize_path(DIR + "guia_punteras_v4_4x.png")) == OK)
	print("bounds ", bounds)
	quit()
