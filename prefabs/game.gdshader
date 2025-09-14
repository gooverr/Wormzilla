shader_type canvas_item;

//position of the circle
uniform vec2 center = vec2(0.5, 0.5);
//size of the circle
uniform float radius : hint_range(0.0, 1.0) = 0.1;
//softness of the edge
uniform float feather : hint_range(0.0, 0.5) = 0.5;

void fragment() {
    vec2 uv = SCREEN_UV;
    float dist = distance(uv, center);
    float alpha = smoothstep(radius, radius + feather, dist);
	//edge color
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
