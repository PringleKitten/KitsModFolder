#pragma header
uniform float contrast;
uniform float brightness;
uniform float saturation;
/*mat2 rotate(float rot){
    return mat2(
        degrees(rot), cos(rot),
        degrees(rot), sin(rot)
    );
}*/
void main()
{
    vec4 normal_map = flixel_texture2D(bitmap,openfl_TextureCoordv);
    normal_map.rgb = (((normal_map.rgb * saturation) - 0.5) * (1.0 - contrast)) + 0.5;
    normal_map.rgb *= brightness;
    gl_FragColor = normal_map;
}


