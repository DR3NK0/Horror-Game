shader_type canvas_item;

uniform float sensivity : hint_range(0.0, 1.0);

void fragment(){
	vec4 original = texture(TEXTURE, UV);
	float mean = (original.x + original.y + original.z) / 3.0;
	vec4 gray = vec4(mean, mean ,mean, original.a); 		
	COLOR = mix(original, gray, sensivity);
}
