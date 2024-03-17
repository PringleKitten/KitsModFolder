#pragma header
uniform float strength;

void main(){
    vec2 uv = openfl_TextureCoordv;
    if(strength != 0.0){
        float pixels = 720.0/((strength/4.0) + 1.0);
        uv = (vec2(ivec2(uv * pixels))+0.5)/pixels;
    }
    gl_FragColor = flixel_texture2D(bitmap,uv);
}