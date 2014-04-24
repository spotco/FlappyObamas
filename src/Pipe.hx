package ;
import flash.display.Sprite;

class Pipe extends Sprite {
	
	private var _wid:Float;
	private var _hei:Float;

	public function new(x:Float, y:Float, wid:Float, hei:Float) {
		super();
		this.x = x;
		this.y = y;
		this._wid = wid;
		this._hei = hei;
		this.graphics.beginFill(0x00FF00);
		this.graphics.drawRect(0, 0, wid, hei);
		this.graphics.endFill();
	}
	
	public function hit_player(x:Float, y:Float):Bool {
		return (x > this.x && x < this.x + this._wid) && (y > this.y && y < this.y + this._hei);
	}
	
}