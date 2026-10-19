extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/avance_derecho_v1/"
const FRAME = "res://../trabajo/arte/revisiones/manos_sota_v1/clave_3_manos_prueba_v1.png"

func _initialize() -> void:
	var frame := Image.load_from_file(ProjectSettings.globalize_path(FRAME))
	assert(frame.get_size() == Vector2i(256, 320))
	var guide := frame.duplicate()
	for dx in range(-4, 5):
		guide.set_pixel(128 + dx, 280, Color8(0, 229, 255))
		guide.set_pixel(152 + dx, 298, Color8(255, 251, 0))
	for dy in range(-4, 5):
		guide.set_pixel(128, 280 + dy, Color8(0, 229, 255))
		guide.set_pixel(152, 298 + dy, Color8(255, 251, 0))
	guide.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(guide.save_png(ProjectSettings.globalize_path(DIR + "guia_fase24_manos_aprobadas_4x.png")) == OK)
	quit()
