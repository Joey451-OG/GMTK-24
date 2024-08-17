shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform int amount = 640;

void fragment(){
	vec2 grid_uv = round(UV * float(amount)) / float(amount);
	vec4 pixel_color = texture(SCREEN_TEXTURE, grid_uv);
	
	COLOR = pixel_color;
}