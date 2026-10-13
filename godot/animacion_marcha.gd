extends RefCounted

# Archivo T05.1 rechazado: solo lo usa la comprobación histórica, no el recorrido.

const ATLASES = [preload("res://assets/personajes/sota/caminar_derecha_v4.png"), preload("res://assets/personajes/sota/caminar_izquierda_v3.png"), preload("res://assets/personajes/sota/caminar_izquierda_v4.png")]
const DATA_PATH = "res://assets/personajes/sota/caminar_v1.json"

var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
var frames: Array = [[], []]
var material := ShaderMaterial.new()


func _init() -> void:
	material.shader = preload("res://assets/personajes/sota/contraluz.gdshader")
	material.set_shader_parameter("rim_width", 3.0)
	var size := Vector2(data.marco[0], data.marco[1])
	var pivot := Vector2(data.pivote[0], data.pivote[1])
	for profile in range(2):
		for frame in data.perfiles[profile]:
			var r: Array = frame.region
			var texture := AtlasTexture.new()
			texture.atlas = ATLASES[frame.atlas]
			texture.region = Rect2(r[0], r[1], r[2], r[3])
			texture.margin = Rect2(pivot.x - (frame.cadera_x - r[0]), pivot.y - r[3], size.x - r[2], size.y - r[3])
			texture.filter_clip = true
			frames[profile].append(texture)


func frame_at(distance: float) -> int:
	return floori(fposmod(distance, data.distancia_ciclo) / data.distancia_ciclo * 8.0)


func apply(sprite: Sprite2D, profile: int, frame: int, height: float = 252.0) -> void:
	sprite.texture = frames[profile][frame]
	sprite.material = material
	sprite.offset = -Vector2(data.pivote[0], data.pivote[1])
	sprite.scale = Vector2.ONE * height / data.altura_referencia
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
