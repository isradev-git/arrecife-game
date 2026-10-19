extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/avance_derecho_manual_v1/"
const BASE = "res://../trabajo/arte/revisiones/manos_sota_v1/clave_3_manos_prueba_v2.png"
const ATLAS = "res://assets/personajes/sota/articulada_v5/marcha.png"

func _initialize() -> void:
	var base := Image.load_from_file(ProjectSettings.globalize_path(BASE))
	var atlas := Image.load_from_file(ProjectSettings.globalize_path(ATLAS))
	var old := atlas.get_region(Rect2i(0, 3 * 320, 256, 320))
	assert(base.get_size() == Vector2i(256, 320))
	for cut in [220, 230, 240, 250]:
		var frame := base.duplicate()
		frame.blit_rect(old, Rect2i(0, cut, 256, 320 - cut), Vector2i(0, cut))
		var zoom := frame.duplicate()
		zoom.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
		assert(zoom.save_png(ProjectSettings.globalize_path(DIR + "union_%d_4x.png" % cut)) == OK)
	var shaped := base.duplicate()
	shaped.blit_rect(old, Rect2i(0, 220, 256, 100), Vector2i(0, 220))
	for y in range(220, 261):
		var limit := 130 if y < 240 else (130 - (y - 240))
		for x in range(80, limit):
			shaped.set_pixel(x, y, base.get_pixel(x, y))
	for y in range(320):
		for x in range(256):
			var pixel: Color = shaped.get_pixel(x, y)
			assert(pixel.a == 0.0 or pixel.a == 1.0)
			if y < 220: assert(pixel == base.get_pixel(x, y))
	var zoom := shaped.duplicate()
	zoom.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(zoom.save_png(ProjectSettings.globalize_path(DIR + "union_pintada_4x.png")) == OK)
	assert(shaped.save_png(ProjectSettings.globalize_path(DIR + "union_pintada_1x.png")) == OK)
	var sheet := Image.create_empty(1024, 320, false, Image.FORMAT_RGBA8)
	sheet.fill(Color8(23, 22, 27))
	for i in range(3):
		var key := Image.load_from_file(ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/manos_sota_v1/clave_%d_manos_prueba_v1.png" % i))
		sheet.blend_rect(key, Rect2i(0, 0, 256, 320), Vector2i(i * 256, 0))
	sheet.blend_rect(shaped, Rect2i(0, 0, 256, 320), Vector2i(768, 0))
	assert(sheet.save_png(ProjectSettings.globalize_path(DIR + "comparacion_1x.png")) == OK)
	var guide := shaped.duplicate()
	for dx in range(-4, 5):
		guide.set_pixel(128 + dx, 280, Color8(0, 229, 255))
		guide.set_pixel(152 + dx, 298, Color8(255, 251, 0))
	for dy in range(-4, 5):
		guide.set_pixel(128, 280 + dy, Color8(0, 229, 255))
		guide.set_pixel(152, 298 + dy, Color8(255, 251, 0))
	guide.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(guide.save_png(ProjectSettings.globalize_path(DIR + "union_pintada_objetivos_4x.png")) == OK)
	var lifted := shaped.duplicate()
	for y in range(251, 294):
		var edge := 130 if y < 265 else (127 if y < 278 else 126)
		for x in range(80, edge):
			lifted.set_pixel(x, y, Color(0, 0, 0, 0))
	for y in range(251, 294):
		var edge := 130 if y < 265 else (127 if y < 278 else 126)
		var rise := mini(5, int((y - 251) / 4))
		for x in range(80, edge):
			var pixel: Color = shaped.get_pixel(x, y)
			if pixel.a == 1.0:
				lifted.set_pixel(x, y - rise, pixel)
	var lift_zoom := lifted.duplicate()
	lift_zoom.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(lift_zoom.save_png(ProjectSettings.globalize_path(DIR + "union_bota_elevada_4x.png")) == OK)
	quit()
