shader_type canvas_item;

uniform sampler2D player_gradient;

//uniform vec4 player_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec4 region = REGION_RECT;
	vec4 original_color = texture(TEXTURE, UV);
	float grayscale_value = (original_color.r + original_color.g + original_color.b) / 3.0;
	vec2 sample_coords = vec2(grayscale_value);
	vec4 gradient_color = texture(player_gradient, sample_coords);
	COLOR.rgb = gradient_color.rgb;
	//COLOR.rgb = grayscale_color_no_alpha;
	//COLOR.a = texture(TEXTURE, UV).a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
