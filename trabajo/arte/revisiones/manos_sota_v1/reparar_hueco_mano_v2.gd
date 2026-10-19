extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/manos_sota_v1/"
const LOWER = "res://../trabajo/arte/revisiones/avance_derecho_v1/avance_derecho_diagnostico_v1.png"

func _initialize() -> void:
	var before := Image.load_from_file(ProjectSettings.globalize_path(DIR + "clave_3_manos_prueba_v1.png"))
	var lower := Image.load_from_file(ProjectSettings.globalize_path(LOWER))
	assert(before.get_size() == Vector2i(256, 320) and lower.get_size() == before.get_size())
	var repaired := before.duplicate()
	var restored := 0
	for y in range(184, 194):
		for x in range(107, 118):
			var cloth := before.get_pixel(x, y + 1)
			if lower.get_pixel(x, y).a == 1.0 and repaired.get_pixel(x, y).a == 0.0 and cloth.a == 1.0:
				repaired.set_pixel(x, y, cloth)
				restored += 1
	# La mano antigua dejó un recorte rectangular en el contorno del pantalón.
	var outline := before.get_pixel(107, 190)
	var fabric := before.get_pixel(108, 190)
	var shadow := before.get_pixel(110, 190)
	for y in range(190, 193):
		for x in range(101, 107):
			assert(repaired.get_pixel(x, y).a == 0.0)
			repaired.set_pixel(x, y, outline if x == 101 else (fabric if x <= 104 else shadow))
			restored += 1
	assert(restored == 21)
	for y in range(320):
		for x in range(256):
			var pixel: Color = repaired.get_pixel(x, y)
			assert(pixel.a == 0.0 or pixel.a == 1.0)
			if y >= 211: assert(pixel == lower.get_pixel(x, y))
			if not Rect2i(100, 184, 18, 10).has_point(Vector2i(x, y)):
				assert(pixel == before.get_pixel(x, y))
	assert(repaired.save_png(ProjectSettings.globalize_path(DIR + "clave_3_manos_prueba_v2.png")) == OK)
	var zoom := repaired.duplicate()
	zoom.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(zoom.save_png(ProjectSettings.globalize_path(DIR + "clave_3_manos_prueba_v2_4x.png")) == OK)
	var crop := Rect2i(85, 165, 65, 60)
	var comparison := Image.create_empty(130, 60, false, Image.FORMAT_RGBA8)
	comparison.fill(Color8(218, 218, 218))
	comparison.blend_rect(before, crop, Vector2i.ZERO)
	comparison.blend_rect(repaired, crop, Vector2i(65, 0))
	comparison.resize(1040, 480, Image.INTERPOLATE_NEAREST)
	assert(comparison.save_png(ProjectSettings.globalize_path(DIR + "hueco_antes_despues_8x.png")) == OK)
	var sheet := Image.create_empty(1024, 320, false, Image.FORMAT_RGBA8)
	sheet.fill(Color8(23, 22, 27))
	for i in range(3):
		var frame := Image.load_from_file(ProjectSettings.globalize_path(DIR + "clave_%d_manos_prueba_v1.png" % i))
		sheet.blend_rect(frame, Rect2i(0, 0, 256, 320), Vector2i(i * 256, 0))
	sheet.blend_rect(repaired, Rect2i(0, 0, 256, 320), Vector2i(768, 0))
	assert(sheet.save_png(ProjectSettings.globalize_path(DIR + "comparacion_manos_prueba_v2.png")) == OK)
	var guide := repaired.duplicate()
	for dx in range(-4, 5):
		guide.set_pixel(128 + dx, 280, Color8(0, 229, 255))
		guide.set_pixel(152 + dx, 298, Color8(255, 251, 0))
	for dy in range(-4, 5):
		guide.set_pixel(128, 280 + dy, Color8(0, 229, 255))
		guide.set_pixel(152, 298 + dy, Color8(255, 251, 0))
	guide.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(guide.save_png(ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/avance_derecho_v1/guia_fase24_hueco_corregido_4x.png")) == OK)
	quit()
