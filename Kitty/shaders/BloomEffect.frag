#pragma header
uniform float strength;
uniform float effect;
uniform float brightness;
uniform float contrast;
void main(){
    vec2 uv = openfl_TextureCoordv;
    vec4 normal_map = flixel_texture2D(bitmap,uv);
    if(effect != 0.0){
        vec3 col0 = (normal_map.rgb - 0.5) * (1.0 - contrast) + 0.5;
        normal_map.rgb += effect * (col0 * strength) * (1.0 + brightness);
    }
    gl_FragColor = normal_map;
}