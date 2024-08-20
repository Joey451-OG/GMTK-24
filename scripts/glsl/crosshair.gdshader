shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform sampler2D CROSSHAIR_MASK : filter_nearest;

void fragment(){
	vec3 rgb_col = vec3(0.4f, 0.7, 0.9);
	vec3 final_col = rgb_col * vec3(1.0-texture(SCREEN_TEXTURE, SCREEN_UV).r, 1.0-texture(SCREEN_TEXTURE, SCREEN_UV).g, 1.0-texture(SCREEN_TEXTURE, SCREEN_UV).b);
	
	COLOR = vec4(final_col, texture(CROSSHAIR_MASK, UV).a);
}