shader_type canvas_item;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	// El alfa generado trae residuos y metal semitransparente; el recorte debe ocultar de verdad.
	if (pixel.a < 0.5) { discard; }
	COLOR = vec4(pixel.rgb, 1.0);
}
