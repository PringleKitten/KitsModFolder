#pragma header
uniform float strength;
uniform float size;
uniform float red;
uniform float green;
uniform float blue;
uniform bool followAlpha;
void main() {
	vec2 uv = openfl_TextureCoordv;
	vec4 color = flixel_texture2D(bitmap,uv);
	if(size != 0.0 && strength != 0.0){
		float sizeVig = size * strength;
		sizeVig /= 12.0;
		vec2 vigUv = pow(sin(uv*3.0),vec2(sizeVig));
		float vig = vigUv.x * vigUv.y;
		color.rgb *= vig;
		color.rgb += (vec3(red,green,blue)/255.0) * (1.0 - vig);
		if(!followAlpha){
			color.a += (1.0 - vig);
		}
	}
	gl_FragColor = color;
}
