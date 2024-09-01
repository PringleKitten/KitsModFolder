#pragma header
uniform float red;
uniform float green;
uniform float blue;
uniform float zoom;
/*mat2 rotate(float rot){
    return mat2(
        degrees(rot), cos(rot),
        degrees(rot), sin(rot)
    );
}*/
void main()
{
    vec4 normal_map = flixel_texture2D(bitmap,openfl_TextureCoordv * zoom);
    normal_map.rgb *= vec3(red,green,blue);
    gl_FragColor = normal_map;
}


