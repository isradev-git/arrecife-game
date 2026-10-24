extends Control

var elapsed := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_motion_enabled(true)

func set_motion_enabled(enabled: bool) -> void:
	visible = enabled
	set_process(enabled)
	if enabled:
		queue_redraw()

func _process(delta: float) -> void:
	elapsed += delta
	queue_redraw()

func _draw() -> void:
	var pulse := 0.58 + 0.35 * sin(elapsed * 1.60) + 0.10 * sin(elapsed * 4.60 + 0.8)
	# Coordenadas editables de fiebre_multitud_v2.png; el original aplanado queda intacto.
	soft_oval(Vector2(0.075, 0.36), Vector2(0.044, 0.20), Color(1.0, 0.08, 0.23), 0.72 * pulse)
	soft_oval(Vector2(0.25, 0.11), Vector2(0.065, 0.15), Color(1.0, 0.06, 0.23), 0.53 * pulse)
	soft_oval(Vector2(0.23, 0.44), Vector2(0.038, 0.14), Color(1.0, 0.06, 0.20), 0.62 * pulse)
	soft_oval(Vector2(0.18, 0.86), Vector2(0.17, 0.065), Color(1.0, 0.04, 0.17), 0.63 * pulse)
	soft_oval(Vector2(0.25, 0.95), Vector2(0.14, 0.035), Color(1.0, 0.05, 0.18), 0.50 * pulse)
	for i in 3:
		var phase := fposmod(elapsed * 0.18 + float(i) * 0.37, 1.0)
		var drift := 0.016 * sin(elapsed * 0.55 + float(i) * 1.7)
		var fade := pow(sin(PI * phase), 2.0)
		soft_oval(Vector2(0.721 + drift, 0.335 - 0.15 * phase), Vector2(0.022 + 0.025 * phase, 0.035 + 0.03 * phase), Color(0.75, 0.88, 0.83), 0.90 * fade)
	var fog_shift := 0.030 * sin(elapsed * 0.75)
	soft_oval(Vector2(0.55 + fog_shift, 0.525), Vector2(0.046, 0.048), Color(0.55, 0.77, 0.78), 0.55)
	soft_oval(Vector2(0.585 - fog_shift, 0.50), Vector2(0.033, 0.055), Color(0.55, 0.77, 0.78), 0.45)

func soft_oval(center: Vector2, radius: Vector2, tint: Color, opacity: float) -> void:
	draw_set_transform(size * center, 0.0, size * radius)
	for i in 7:
		var color := tint
		color.a = opacity * (0.07 + 0.02 * float(i))
		draw_circle(Vector2.ZERO, 1.0 - float(i) * 0.12, color)
	draw_set_transform(Vector2.ZERO)
