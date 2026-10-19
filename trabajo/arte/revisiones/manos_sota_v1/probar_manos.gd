extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/manos_sota_v1/"
const ATLAS = "res://assets/personajes/sota/articulada_v5/marcha.png"
const LOWER = [
	"res://../trabajo/arte/revisiones/contacto_derecha_diagnostico_v1/contacto_derecha_prueba_v2.png",
	"res://../trabajo/arte/revisiones/apoyo_derecho_v1/apoyo_derecho_prueba_v1.png",
	"res://../trabajo/arte/revisiones/impulso_derecho_v1/impulso_derecho_prueba_v1.png",
	"res://../trabajo/arte/revisiones/avance_derecho_v1/avance_derecho_diagnostico_v1.png"
]

func _initialize() -> void:
	var atlas := Image.load_from_file(ProjectSettings.globalize_path(ATLAS))
	assert(atlas.get_size() == Vector2i(2048, 2560))
	var sheet := Image.create_empty(1024, 320, false, Image.FORMAT_RGBA8)
	sheet.fill(Color8(23, 22, 27))
	var before := sheet.duplicate()
	var first: Image
	for i in range(4):
		var old := atlas.get_region(Rect2i(0, i * 320, 256, 320))
		var lower := Image.load_from_file(ProjectSettings.globalize_path(LOWER[i]))
		assert(lower.get_size() == Vector2i(256, 320))
		before.blend_rect(lower, Rect2i(0, 0, 256, 320), Vector2i(i * 256, 0))
		var frame := lower.duplicate()
		frame.blit_rect(old, Rect2i(0, 0, 256, 174), Vector2i.ZERO)
		# shortcut: piel detectada por color en v5; redibujar dedos si el contorno se corta.
		for y in range(174, 211):
			for x in range(85, 123):
				var near_old_skin := false
				for sy in range(maxi(170, y - 3), mini(211, y + 4)):
					for sx in range(maxi(85, x - 3), mini(123, x + 4)):
						var c := lower.get_pixel(sx, sy)
						if c.a >= 0.95 and c.r > 0.36 and c.g > 0.22 and c.b > 0.14 and c.r > c.g * 1.15 and c.g > c.b * 1.08:
							near_old_skin = true
							break
					if near_old_skin: break
				if near_old_skin: frame.set_pixel(x, y, Color(0, 0, 0, 0))
		for y in range(174, 211):
			for x in range(75, 180):
				var near_skin := false
				for sy in range(maxi(170, y - 3), mini(211, y + 4)):
					for sx in range(maxi(75, x - 3), mini(180, x + 4)):
						var c := old.get_pixel(sx, sy)
						if c.a >= 0.95 and c.r > 0.35 and c.g > 0.19 and c.b > 0.09 and c.r > c.g * 1.25 and c.g > c.b * 1.15:
							near_skin = true
							break
					if near_skin: break
				if near_skin: frame.set_pixel(x, y, old.get_pixel(x, y))
		var hand_skin_count := 0
		for y in range(174, 230):
			for x in range(75, 180):
				var c := old.get_pixel(x, y)
				if c.a >= 0.95 and c.r > 0.35 and c.g > 0.19 and c.b > 0.09 and c.r > c.g * 1.25 and c.g > c.b * 1.15:
					assert(y < 211)
					assert(frame.get_pixel(x, y) == c)
					hand_skin_count += 1
		assert(hand_skin_count > 30)
		var arm_changes := 0
		for y in range(320):
			for x in range(256):
				var pixel: Color = frame.get_pixel(x, y)
				assert(pixel.a == 0.0 or pixel.a == 1.0)
				if y >= 211: assert(pixel == lower.get_pixel(x, y))
				if i > 0 and x >= 75 and x < 180 and y >= 110 and y < 211 and pixel != first.get_pixel(x, y):
					arm_changes += 1
		if i == 0: first = frame.duplicate()
		else: assert(arm_changes > 100)
		assert(frame.save_png(ProjectSettings.globalize_path(DIR + "clave_%d_manos_prueba_v1.png" % i)) == OK)
		var zoom := frame.duplicate()
		zoom.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
		assert(zoom.save_png(ProjectSettings.globalize_path(DIR + "clave_%d_manos_prueba_v1_4x.png" % i)) == OK)
		sheet.blend_rect(frame, Rect2i(0, 0, 256, 320), Vector2i(i * 256, 0))
	assert(sheet.save_png(ProjectSettings.globalize_path(DIR + "comparacion_manos_prueba_v1.png")) == OK)
	var comparison := Image.create_empty(1024, 640, false, Image.FORMAT_RGBA8)
	comparison.blit_rect(before, Rect2i(0, 0, 1024, 320), Vector2i.ZERO)
	comparison.blit_rect(sheet, Rect2i(0, 0, 1024, 320), Vector2i(0, 320))
	assert(comparison.save_png(ProjectSettings.globalize_path(DIR + "antes_despues_manos_v1.png")) == OK)
	var details := Image.create_empty(400, 110, false, Image.FORMAT_RGBA8)
	details.fill(Color8(23, 22, 27))
	for i in range(4):
		var frame := Image.load_from_file(ProjectSettings.globalize_path(DIR + "clave_%d_manos_prueba_v1.png" % i))
		details.blend_rect(frame, Rect2i(75, 110, 100, 110), Vector2i(i * 100, 0))
	details.resize(1600, 440, Image.INTERPOLATE_NEAREST)
	assert(details.save_png(ProjectSettings.globalize_path(DIR + "detalle_manos_4x.png")) == OK)
	var atlas_details := Image.create_empty(400, 110, false, Image.FORMAT_RGBA8)
	atlas_details.fill(Color8(23, 22, 27))
	for i in range(4):
		atlas_details.blend_rect(atlas, Rect2i(75, i * 320 + 110, 100, 110), Vector2i(i * 100, 0))
	atlas_details.resize(1600, 440, Image.INTERPOLATE_NEAREST)
	assert(atlas_details.save_png(ProjectSettings.globalize_path(DIR + "detalle_referencia_v5_4x.png")) == OK)
	var hand_comparison := Image.create_empty(1600, 880, false, Image.FORMAT_RGBA8)
	hand_comparison.blit_rect(atlas_details, Rect2i(0, 0, 1600, 440), Vector2i.ZERO)
	hand_comparison.blit_rect(details, Rect2i(0, 0, 1600, 440), Vector2i(0, 440))
	assert(hand_comparison.save_png(ProjectSettings.globalize_path(DIR + "comparacion_detalle_manos_4x.png")) == OK)
	quit()
