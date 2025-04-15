package vsrg.core.shaders;

import flixel.system.FlxAssets;

class HueShifter
{
    public var shader:HueShifterShader;
    public var hue(default, set):Float;

    function set_hue(f:Float)
    {
        hue = f;
        return shader.uHueDeg.value[0] = f;
    }
	public function new():Void
	{
        shader = new HueShifterShader();
		shader.uHueDeg.value = [0];
	}
}
private class HueShifterShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float uHueDeg; // hue in degreess, -180 to 180

        // both functions taken from github
        // https://gist.github.com/983/e170a24ae8eba2cd174f
        vec3 rgb2hsv(vec3 c)
        {
            vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
            vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

            float d = q.x - min(q.w, q.y);
            float e = 1.0e-10;
            return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
        }

        vec3 hsv2rgb(vec3 c)
        {
            vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
            return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
        }

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

            // convert to hsv
            vec3 hsv = rgb2hsv(color.rgb);
            float hueShift = uHueDeg / 360.0;
            
            // instead of fract by negative values ??
            hsv.x = mod(hsv.x + hueShift, 1.0);

            // convert to again to rgb
            color.rgb = hsv2rgb(hsv);
            gl_FragColor = color;
        }
    ')
	public function new()
	{
		super();
	}
}
