package ;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.Graphics;
	import flash.geom.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import openfl.Assets;
	
class Util {
	public function new(){}
	
	public static function pt_dist(x_0:Float, y_0:Float, x_1:Float, y_1:Float):Float {
		return Math.sqrt(Math.pow(x_1 - x_0, 2) + Math.pow(y_1 - y_0, 2));
	}
	
	static var tf:TextField = new TextField();
	
	public static function render_text(tar:Graphics, text:String, x:Float, y:Float, fontsize:Float = 12, color:UInt = 0x000000):Void {
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.textColor = color;
		tf.embedFonts = true;
		
		
		tf.defaultTextFormat = new TextFormat(Assets.getFont("gamefont").fontName,fontsize);
		tf.text = text;
		
		var text_bitmap:BitmapData = new BitmapData(cast(tf.width,Int), cast(tf.height,Int), true, 0x00000000);
		text_bitmap.draw(tf);
		
		var typeTextTranslationX:Float =  x;
		var typeTextTranslationY:Float = y;
		var matrix:Matrix = new Matrix();
		matrix.translate(typeTextTranslationX, typeTextTranslationY);
		
		tar.lineStyle();
		tar.beginBitmapFill(text_bitmap, matrix, true, true);
		tar.drawRect(typeTextTranslationX, typeTextTranslationY, tf.width, tf.height);
		tar.endFill();
	}
	
}