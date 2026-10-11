shader_type canvas_item;

uniform vec4 left_color : source_color = vec4(1.0, 0.04, 0.18, 1.0);
uniform vec4 right_color : source_color = vec4(1.0, 0.42, 0.04, 1.0);
uniform vec2 left_direction = vec2(-1.0, -0.35);
uniform vec2 right_direction = vec2(1.0, -0.35);
uniform float rim_strength : hint_range(0.0, 1.0) = 0.7;
uniform float rim_width : hint_range(1.0, 12.0) = 6.0;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	if (pixel.a < 0.1) {
		discard;
	}
	// shortcut: máscara del borde alfa; añadir máscara artística para reflejos interiores y oclusiones.
	vec2 offset = TEXTURE_PIXEL_SIZE * rim_width;
	float left_mask = 1.0 - step(0.1, texture(TEXTURE, UV + offset * left_direction).a);
	float right_mask = 1.0 - step(0.1, texture(TEXTURE, UV + offset * right_direction).a);
	pixel.rgb = mix(pixel.rgb, left_color.rgb, left_mask * rim_strength * left_color.a);
	pixel.rgb = mix(pixel.rgb, right_color.rgb, right_mask * rim_strength * right_color.a);
	COLOR = pixel;
}
