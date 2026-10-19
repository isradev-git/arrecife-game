extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/avance_derecho_manual_v1/"

func _initialize() -> void:
	for version in [4, 5]:
		var atlas := Image.load_from_file(ProjectSettings.globalize_path("res://assets/personajes/sota/articulada_v%d/marcha.png" % version))
		var frame := atlas.get_region(Rect2i(0, 3 * 320, 256, 320))
		frame.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
		assert(frame.save_png(ProjectSettings.globalize_path(DIR + "fase24_atlas_v%d_4x.png" % version)) == OK)
	quit()
