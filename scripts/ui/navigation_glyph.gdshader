shader_type canvas_item;
// Isolate the bright embossed reference glyph at draw time, preserving its relief.
uniform bool source_teal = false;
uniform bool selected = false;
void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float light = max(source.r, max(source.g, source.b));
	float material_mask = source_teal ? source.g - source.r : source.r - source.b;
	float mask = smoothstep(0.025, 0.13, material_mask) * smoothstep(0.14, 0.4, light);
	vec3 color = source.rgb;
	if (selected && !source_teal) color = vec3(0.23, 0.96, 0.82) * light;
	if (!selected && source_teal) color = vec3(1.0, 0.79, 0.43) * light;
	COLOR = vec4(color, source.a * mask);
}
