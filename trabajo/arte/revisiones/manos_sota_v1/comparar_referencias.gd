extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/manos_sota_v1/"
const CURRENT = [
	"res://../trabajo/arte/revisiones/contacto_derecha_diagnostico_v1/contacto_derecha_prueba_v2.png",
	"res://../trabajo/arte/revisiones/apoyo_derecho_v1/apoyo_derecho_prueba_v1.png",
	"res://../trabajo/arte/revisiones/impulso_derecho_v1/impulso_derecho_prueba_v1.png",
	"res://../trabajo/arte/revisiones/avance_derecho_v1/avance_derecho_diagnostico_v1.png"
]

func _initialize() -> void:
	for version in ["v4", "v5"]:
		var atlas_path := "res://assets/personajes/sota/articulada_%s/marcha.png" % ("v1" if version == "v4" else "v5")
		var atlas := Image.load_from_file(ProjectSettings.globalize_path(atlas_path))
		assert(atlas.get_size() == Vector2i(2048, 2560))
		var comparison := Image.create_empty(1024, 640, false, Image.FORMAT_RGBA8)
		comparison.fill(Color8(23, 22, 27))
		for i in range(4):
			var old := atlas.get_region(Rect2i(0, i * 320, 256, 320))
			comparison.blend_rect(old, Rect2i(0, 0, 256, 320), Vector2i(i * 256, 0))
			var current := Image.load_from_file(ProjectSettings.globalize_path(CURRENT[i]))
			assert(current.get_size() == Vector2i(256, 320))
			comparison.blend_rect(current, Rect2i(0, 0, 256, 320), Vector2i(i * 256, 320))
		assert(comparison.save_png(ProjectSettings.globalize_path(DIR + version + "_frente_a_claves_actuales.png")) == OK)
	quit()
