shader_type canvas_item;

uniform bool recolor_rim = false;
uniform float alpha_threshold = 0.1;
uniform bool opaque_cutout = false;
uniform vec4 pink_rim : source_color = vec4(1.0);
uniform vec4 warm_rim : source_color = vec4(1.0);
uniform vec4 pixel_tint : source_color = vec4(1.0);

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	if (pixel.a < alpha_threshold) {
		discard;
	}
	if (opaque_cutout) {
		pixel.a = 1.0;
	}
	// shortcut: selección de neón propia de Sota v7; usar máscara explícita al producir animaciones.
	if (recolor_rim) {
		bool pink = pixel.r > 0.6 && pixel.b > pixel.g + 0.08 && pixel.r > pixel.b * 1.2;
		bool warm = pixel.r > 0.85 && pixel.g > 0.18 && pixel.g < 0.75 && pixel.b < pixel.g * 0.55;
		if (pink) {
			pixel.rgb = pink_rim.rgb * pixel.r;
		} else if (warm) {
			pixel.rgb = warm_rim.rgb * pixel.r;
		}
	}
	COLOR = pixel * pixel_tint;
}
