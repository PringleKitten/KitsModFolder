#pragma header

uniform float fade;
uniform float red;
uniform float green;
uniform float blue;
void main()
{
    vec4 normal_map = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec3 fill = vec3(red,green,blue)/255.0;
    normal_map.rgb = mix(fill,normal_map.rgb,fade);
    normal_map *= normal_map.a;
    gl_FragColor = normal_map;
}