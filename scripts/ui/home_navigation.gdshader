shader_type canvas_item;
// Reference artwork is unchanged. Move only the active enamel light to its destination.
uniform int active_tab = 1;
void fragment() {
	vec4 source = texture(TEXTURE, UV);
	vec2 p = vec2(UV.x * 941.0, UV.y * 1672.0 - 1481.0);
	vec3 color = source.rgb;
	if (active_tab != 1) {
		float teal = smoothstep(0.015, 0.16, source.g - source.r);
		bool home_icon = p.x > 423.0 && p.x < 522.0 && p.y > 21.0 && p.y < 101.0;
		float light = max(source.r, max(source.g,source.b));
		color = mix(color, vec3(0.035,0.066,0.085) + source.r*0.22, teal);
		if (home_icon) {
			color = mix(color, vec3(1.0,0.76,0.40)*light, teal*smoothstep(0.22,0.50,light));
		}
		float erase_line = smoothstep(360.0,395.0,p.x)*(1.0-smoothstep(548.0,580.0,p.x));
		erase_line *= smoothstep(137.0,148.0,p.y)*(1.0-smoothstep(174.0,187.0,p.y));
		vec3 clean = texture(TEXTURE,vec2((225.0+(p.x-375.0)*0.15)/941.0,UV.y)).rgb;
		float clean_teal=smoothstep(0.015,0.16,clean.g-clean.r);
		clean=mix(clean,vec3(0.035,0.066,0.085)+clean.r*0.22,clean_teal);
		color=mix(color,clean,erase_line);
		float erase_pointer=smoothstep(440.0,458.0,p.x)*(1.0-smoothstep(483.0,501.0,p.x));
		erase_pointer *= 1.0-smoothstep(8.0,15.0,p.y);
		color=mix(color,texture(TEXTURE,vec2((p.x-160.0)/941.0,UV.y)).rgb,erase_pointer);
		float center = active_tab == 2 ? 771.0 : 168.0;
		vec2 glow_delta = (p - vec2(center,77.0))/vec2(73.0,65.0);
		float glow = exp(-dot(glow_delta,glow_delta)*1.35);
		color += vec3(0.0,0.24,0.19)*glow*(1.0-smoothstep(0.16,0.55,light));
		bool active_icon = abs(p.x-center)<49.0 && p.y>20.0 && p.y<103.0;
		if (active_icon) {
			float gold = smoothstep(0.04,0.23,source.r-source.b);
			color = mix(color,vec3(0.22,1.0,0.83)*light,gold);
		}
		// Relocate the original soft underline and top pointer, preserving their texture.
		if ((p.y>146.0 && p.y<178.0 || p.y<12.0) && abs(p.x-center)<90.0) {
			vec2 sample_uv = vec2((p.x-center+470.0)/941.0,UV.y);
			vec3 accent = texture(TEXTURE,sample_uv).rgb;
			float mask = smoothstep(0.08,0.2,accent.g-accent.r);
			color=mix(color,accent,mask);
		}
	}
	COLOR=vec4(color,source.a);
}
