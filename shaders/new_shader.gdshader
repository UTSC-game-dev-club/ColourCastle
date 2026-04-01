shader_type spatial;
render_mode unshaded;

uniform vec4 color_a : source_color = vec4(1.0, 0.8, 0.8, 1.0);
uniform vec4 color_b : source_color = vec4(1.0, 0.4, 0.4, 1.0);

varying vec3 local_pos;

void vertex() {
    local_pos = VERTEX;
}

void fragment() {
    float t = (local_pos.x + 0.5); // assuming roughly [-0.5, 0.5]
t = clamp(t, 0.0, 1.0);
    ALBEDO = mix(color_a.rgb, color_b.rgb, t);
}