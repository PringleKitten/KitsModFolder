#pragma header

uniform float x;
uniform float y;
uniform float zoom;
uniform float angle;
uniform bool flip;

void main()
{
    vec2 uv = openfl_TextureCoordv - 0.5;

    if(mod(angle, 360.0) != 0.0){
        float r = radians(-angle);
        float c = cos(r), s = sin(r);

        uv *= mat2(
            vec2(c, -s),
            vec2(s,  c)
        );
    }

    // Scale and apply offset positions
    uv = uv * zoom + vec2(x, y);

    if (flip) {
        uv = 1.0 - abs(mod(uv - 0.5, 2.0) - 1.0);
    } else {
        uv = fract(uv + 0.5);
    }
    
    gl_FragColor = flixel_texture2D(bitmap, uv);
}