shader_type canvas_item;
// Rounded runtime clipping of reference UI atlas regions; keep original texture untouched.
uniform vec2 extent = vec2(100.0);
uniform float radius = 20.0;
uniform float inset = 1.0;
varying vec2 local_position;
void vertex() { local_position = VERTEX; }
void fragment() {
	vec2 half_size = extent * 0.5 - vec2(inset);
	float r = min(radius, min(half_size.x, half_size.y));
	vec2 q = abs(local_position - extent * 0.5) - half_size + vec2(r);
	float distance_to_edge = length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - r;
	COLOR.a *= 1.0 - smoothstep(-0.7, 0.7, distance_to_edge);
}
