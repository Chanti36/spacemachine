shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float fisheye_strength = 1.0; // Control the fisheye effect strength

vec2 fisheye(vec2 uv)
{
	vec2 d = uv - 0.5;
	float r = length(d);
	float theta = atan(d.y, d.x);
	float rf = pow(r, fisheye_strength) / pow(0.5, fisheye_strength - 1.0);
	return (vec2(0.5) + rf * normalize(d));
	}

void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 q = FRAGCOORD.xy / iResolution.xy;

	// Apply fisheye distortion
	q = fisheye(q);
	vec3 col = texture(screen_texture, q).rgb;
	COLOR = vec4(col, 1.0);
}

//v1 texture vec2__________________________________________________________________________


//shader_type canvas_item;
//
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//uniform vec2 center = vec2(0.5, 0.5);
//uniform vec2 screenRatio = vec2(1.333333, 1.0);//800/600, 1
//
//uniform float intensity :hint_range(0.0, 0.5) = 0.1; //power
//uniform float progress : hint_range(0, 1); //radius
//uniform float cropEdge : hint_range(0, 1); //radius
//uniform float cropColor : hint_range(0, 1); //radius
//
//void fragment()
//{
	//vec2 uv = UV;
	//vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	//vec2 aspect_uv = uv;
	//aspect_uv.x *= resolution.x / resolution.y;
	//
	//vec2 eyeUV = center;
	//eyeUV.x *= resolution.x / resolution.y;
	////float
	//float dist = distance(eyeUV, aspect_uv);
	//float warp = clamp( 0.5 - pow(dist /progress, 5.0), 0.0, 1.0);
	//float mag_factor = pow(warp, 1.0 / intensity);
	//
	//uv += mag_factor *(center -uv);
	//
	//if (dist < progress)
	//{
		//COLOR.a = 0.0;
	//}
	//else
		//COLOR = texture(TEXTURE, uv);
//}

//BLUR (uses screentext and texturelod)__________________________________________________________________________
//void fragment()
//{
    //vec2 correctedUV = (UV - center) * screenRatio + center;
	//float dist = length(correctedUV - center);
	//float radius = sqrt(8.0) * abs(progress - 0.5);
  //
	//if (dist > radius)
	//{
		////float _step = smoothstep(dist, radius, intensity);
		//vec4 color =textureLod(SCREEN_TEXTURE, SCREEN_UV, blur);
		//COLOR = color;
	//}
	//else
	//{
		//COLOR.a = 0.0;
	//}
//}