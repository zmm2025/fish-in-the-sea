shader_type canvas_item;

// Scale of the noise (zoom level): higher = finer detail, lower = larger blobs
uniform float scale : hint_range(0.0001, 0.02) = 0.001;
// Rect size (set automatically by SeaBackgroundRect script when resized)
uniform vec2 rect_size = vec2(10000.0, 10000.0);
// Darker tint for deeper water (bottom of rect)
uniform float gradient_strength : hint_range(0.0, 1.0) = 0.12;
uniform vec4 depth_tint : source_color = vec4(0.1, 0.25, 0.5, 1.0);

varying vec2 local_pos;

float random(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
	vec2 uv_index = floor(uv);
	vec2 uv_fract = fract(uv);

	float a = random(uv_index);
	float b = random(uv_index + vec2(1.0, 0.0));
	float c = random(uv_index + vec2(0.0, 1.0));
	float d = random(uv_index + vec2(1.0, 1.0));

	vec2 blur = smoothstep(0.0, 1.0, uv_fract);

	return mix(a, b, blur.x) +
		(c - a) * blur.y * (1.0 - blur.x) +
		(d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
	float amplitude = 0.5;
	float frequency = 3.0;
	float value = 0.0;

	for (int i = 0; i < 6; i++) {
		value += amplitude * noise(frequency * uv);
		amplitude *= 0.5;
		frequency *= 2.0;
	}
	return value;
}

void vertex() {
	local_pos = VERTEX.xy;
}

void fragment() {
	// Relative gradient: 0 at top of rect, 1 at bottom (same shade at top/bottom edges for any rect size)
	float depth_factor = (rect_size.y > 0.0) ? (local_pos.y / rect_size.y) : 0.0;
	vec4 gradient = mix(COLOR, depth_tint, depth_factor * gradient_strength);

	// fBM: local_pos relative to rect center so noise scales with rect
	vec2 local_center = local_pos - rect_size * 0.5;
	float n = fbm(local_center * scale);
	n = (n - 0.5) * 0.06;
	COLOR = gradient + vec4(n, n * 0.8, n * 0.5, 0.0);
}
