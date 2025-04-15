package vsrg.core;

class Constants
{
	public static final ANIMATION_PER_LANE:Array<String> = ['left', 'down', 'up', 'right'];
	public static final ROTATION_PER_LANE:Array<Float> = [90, 0, 180, -90];
	public static final HUE_PER_LANE:Array<Float> = [-60, -130, 110, 20];

	// 0.15ms
	public static final VALID_HIT_WINDOW:Float = 150;

	public static final EARLY_WINDOW_MULT:Float = 0.5;
	public static final LATE_WINDOW_MULT:Float = 1;
}
