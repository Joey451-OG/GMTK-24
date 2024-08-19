shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform int amount = 540;

void fragment() {
	vec2 grid_uv = round(UV * float(amount)) / float(amount);
	vec4 text = texture(SCREEN_TEXTURE, grid_uv);
	
	COLOR = text;
}