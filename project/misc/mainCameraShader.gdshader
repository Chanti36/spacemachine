// Converted from https://www.shadertoy.com/view/td2GzW
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Anti fish eye (negative amount) / fish eye (positive)
uniform float effect_amount : hint_range(-2.5, 2.5) = 1.0;


uniform float aberration_amount : hint_range(0.0, 10.0, 0.01) = 0.0;
uniform vec2 screen_size = vec2(320.0, 180.0);
uniform bool show_curvature = true;
uniform float curvature_x_amount : hint_range(3.0, 15.0, 0.01) = float(6.0);
uniform float curvature_y_amount : hint_range(3.0, 15.0, 0.01) = float(4.0);
uniform vec4 corner_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool show_vignette = true;
uniform float vignette_opacity : hint_range(0.0, 1.0, 0.01) = 0.2;


void fragment()
{
	// glsl -> godot shader
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec4 fragCoord = FRAGCOORD;

	//normalized coords
	vec2 p = fragCoord.xy / iResolution.x;
	//screen proroption
	float prop = iResolution.x / iResolution.y;
	//center coords
	vec2 m = vec2(0.5, 0.5 / prop);
	//vector from center to current fragment
	vec2 d = p - m;
	// distance of pixel from center
	float r = sqrt(dot(d, d));
	//radius of 1:1 effect
	float bind;

	//stick to borders
	if (effect_amount > 0.0)
		bind = sqrt(dot(m, m));
	else
	{
		if (prop < 1.0)
			bind = m.x;
		else
			bind = m.y;
	}

	vec2 uv;
	//fisheye
	if (effect_amount > 0.0)
		uv = m + normalize(d) * tan(r * effect_amount) * bind / tan( bind * effect_amount);
	//antifisheye
	else if (effect_amount < 0.0)
		uv = m + normalize(d) * atan(r * -effect_amount * 10.0) * bind / atan(-effect_amount * bind * 10.0);
	//no effect for power = 1.0
	else
		uv = p;
    uv.y *= prop;

	vec3 color = texture(SCREEN_TEXTURE, uv).rgb;



	if (aberration_amount > 0.0) {
		float adjusted_amount = aberration_amount / screen_size.x;
		color.r = texture(SCREEN_TEXTURE, vec2(uv.x + adjusted_amount, uv.y)).r;
		color.g = texture(SCREEN_TEXTURE, uv).g;
		color.b = texture(SCREEN_TEXTURE, vec2(uv.x - adjusted_amount, uv.y)).b;
	}

	if (show_vignette) {
		float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
		vignette = clamp(pow((screen_size.x / 4.0) * vignette, vignette_opacity), 0.0, 1.0);
		color *= vignette;
	}


	COLOR = vec4(color, 1.0);
}