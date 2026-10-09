shader_type canvas_item;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	if (pixel.a < 0.1) {
		discard;
	}
	COLOR = pixel;
}
