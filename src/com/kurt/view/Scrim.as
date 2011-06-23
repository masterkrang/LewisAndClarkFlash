package com.kurt.view
{
	import flash.display.Sprite;
	
	public class Scrim extends Sprite
	{
		public var scrimLayer:Sprite;
		public var _color:int;
		public var _width:Number;
		public var _height:Number;
		//public var _alpha;
		
		public function Scrim(c:int, w:Number, h:Number)
		{
			super();
			
			
			_color = c;
			_width = w;
			_height = h;
			
			init();
		}
		
		public function init():void {
			scrimLayer = new Sprite();
			scrimLayer.graphics.beginFill(_color);
			scrimLayer.graphics.drawRect(0,0,_width,_height);
			scrimLayer.graphics.endFill();
			addChild(scrimLayer);
		}
		
		public function resize(w:Number, h:Number):void {
			if(scrimLayer) {
				scrimLayer.width = w;
				scrimLayer.height = h;
			}
		}
	}
}