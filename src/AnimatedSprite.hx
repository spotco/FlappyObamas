package ;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author sdaf
 */
class AnimatedSprite extends Sprite {

	private var _bitmaps = new Array<Bitmap>();
	private var _duration:Float;
	
	private var _ct:Float = 0;
	private var _bitmaps_i:Int = 0;
	
	public function new(source_files:Array<String>, duration:Float) {
		super();
		for (i in source_files) {
			_bitmaps.push(new Bitmap(Assets.getBitmapData(i)));
		}
		_duration = duration;
		
		this.addChild(_bitmaps[_bitmaps_i]);
		
		this.addEventListener(Event.ENTER_FRAME, function(e):Void {
			anim_update();
		});
	}
	
	public function anim_update():Void {
		_ct++;
		if (_ct > _duration) {
			while (this.numChildren > 0) this.removeChildAt(0);
			_bitmaps_i = (_bitmaps_i + 1) % _bitmaps.length;
			this.addChild(_bitmaps[_bitmaps_i]);
			_ct = 0;
		}
	}
	
}