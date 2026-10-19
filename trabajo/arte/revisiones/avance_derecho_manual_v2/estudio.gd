extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/avance_derecho_manual_v2/"
const UPPER = "res://../trabajo/arte/revisiones/manos_sota_v1/clave_3_manos_prueba_v2.png"
const V4 = "res://assets/personajes/sota/articulada_v4/marcha.png"


func _initialize() -> void:
	var upper := Image.load_from_file(ProjectSettings.globalize_path(UPPER))
	var atlas := Image.load_from_file(ProjectSettings.globalize_path(V4))
	assert(upper.get_size() == Vector2i(256, 320))
	var reference := atlas.get_region(Rect2i(0, 3 * 320, 256, 320))
	for cut in [220, 230, 240]:
		var candidate := upper.duplicate()
		candidate.blit_rect(reference, Rect2i(0, cut, 256, 320 - cut), Vector2i(0, cut))
		var sheet := Image.create_empty(512, 320, false, Image.FORMAT_RGBA8)
		sheet.fill(Color8(30, 29, 34))
		sheet.blend_rect(upper, Rect2i(0, 0, 256, 320), Vector2i.ZERO)
		sheet.blend_rect(candidate, Rect2i(0, 0, 256, 320), Vector2i(256, 0))
		assert(sheet.save_png(ProjectSettings.globalize_path(DIR + "corte_%d_1x.png" % cut)) == OK)
		sheet.resize(1024, 640, Image.INTERPOLATE_NEAREST)
		assert(sheet.save_png(ProjectSettings.globalize_path(DIR + "corte_%d_2x.png" % cut)) == OK)
	quit()
