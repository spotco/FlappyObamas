package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.*;
import openfl.Assets;

/**
 * ...
 * @author sdaf
 */

class Main extends Sprite 
{
	var inited:Bool;
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
	
	function resize(e) {
		if (!inited) init();
		// else (resize or orientation change)
	}

	public function new() {
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) {
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static var WID:Int = 800;
	public static var HEI:Int = 480;
	
	private var _bird:Sprite = new Sprite();
	private var _tapped:Bool = false;
	private var _bird_vy:Float = 0;
	private var _is_gameover:Bool = false;
	
	private var _ui_draw:Sprite = new Sprite();
	
	function init() {
		if (inited) return;
		inited = true;

		WID = stage.stageWidth;
		HEI = stage.stageHeight;
		
		this.addChild(new Bitmap(Assets.getBitmapData("img/background.png")));
		this.addChild(_ui_draw);
		
		//var img = new Bitmap(Assets.getBitmapData("img/obama_0.png"));
		var img = new AnimatedSprite(["img/obama_0.png", "img/obama_1.png", "img/obama_2.png", "img/obama_3.png"], 5);
		img.x = -20;
		img.y = -20;
		_bird.addChild(img);
		this.addChild(_bird);
		
		Util.render_text(_ui_draw.graphics, ""+_jump_count, 0, 0, 32);
		
		start_game();
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
			_tapped = true;
		});
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, function(e:MouseEvent) {
			_tapped = true;
		});	
		stage.addEventListener(Event.ENTER_FRAME, function(e:Event) {
			update();
		});
	}
	

	private var _pipes:Array<Pipe> = new Array();
	private var _pipe_spawn_ct:Int = 0;
	private var _jump_count:Int = 0;
	
	public function update():Void {
		if (_is_gameover) {
			if (_tapped) {
				while (_pipes.length > 0) {
					this.removeChild(_pipes.pop());
				}
				start_game();
			}
			_tapped = false;
			return;
		}
		
		if (_tapped) {
			_bird_vy = -8;
			
			Assets.getSound("sfx/Pickup_Coin.wav").play();
			
			
			_ui_draw.graphics.clear();
			_jump_count++;
			Util.render_text(_ui_draw.graphics, ""+_jump_count, 0, 0, 32);
			
		} else {
			_bird_vy += 0.5;
		}
		_bird.y += _bird_vy;
		
		if (_bird.y > HEI || _bird.y < 0) {
			game_over();
		}
		
		_pipe_spawn_ct++;
		if (_pipe_spawn_ct % 40 == 0) {
			var p = new Pipe(
				WID,
				rand_range(0, HEI),
				20,
				200
			);
			_pipes.push(p);
			this.addChild(p);
		}
		
		var i = _pipes.length - 1;
		while (i >= 0) {
			var p = _pipes[i];
			p.x -= 5;
			if (p.hit_player(_bird.x, _bird.y)) {
				game_over();
			} else if (p.x < 0) {
				_pipes.remove(p);
				this.removeChild(p);
			}
			i--;
		}
		
		_tapped = false;
	}
	
	private function rand_range(min:Float, max:Float):Float {
		return min + Math.random() * (max - min);
	}
	
	public function start_game():Void {
		_bird.x = WID * 0.2;
		_bird.y = HEI * 0.5;
		_bird_vy = 0;
		_is_gameover = false;
		_jump_count = 0;
	}
	
	private function game_over():Void {
		_is_gameover = true;
		Assets.getSound("sfx/Pickup_Explode.wav").play();
	}
}
