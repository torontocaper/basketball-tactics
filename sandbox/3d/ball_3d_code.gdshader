shader_type spatial;

uniform int segments = 6;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	METALLIC = 0.0;
	SPECULAR = 0.0;
	ROUGHNESS = 1.0;
	if (UV.x < 1.0/float(segments) || (UV.x >= 3.0/float(segments) && UV.x < 4.0/float(segments))) {
		ALBEDO = vec3(1.0, 0.0, 0.0);
	}
	else if (UV.x < 2.0/float(segments) || (UV.x >= 4.0/float(segments) && UV.x < 5.0/float(segments))) {
		ALBEDO = vec3(0.0, 0.0, 1.0);
	}
	else {
		ALBEDO = vec3(1.0, 1.0, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
