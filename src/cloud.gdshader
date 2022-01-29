// NOTE: Shader automatically converted from Godot Engine 3.4.2.stable's SpatialMaterial.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform vec4 white_color : hint_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 gray_color : hint_color =  vec4(1.0,1.0,1.0,0.5);

varying flat vec3 out_color;

vec3 lerpColor(vec4 a, vec4 b, float t) {
	float rr = a.r + (b.r - a.r) * t;
	float gg = a.g + (b.g - a.b) * t;
	float bb = a.b + (b.b - a.b) * t;
	return vec3(rr,gg,bb);
}

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	
	out_color = vec3(white_color.r,gray_color.g,gray_color.b);
	if (VERTEX.y > 1.0) {
		out_color = lerpColor(white_color, gray_color, clamp((VERTEX.y - 1.0) / 3.0, 0.0, 1.0));
	}
} 


void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = out_color ;//* albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
