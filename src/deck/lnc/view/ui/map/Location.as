package deck.lnc.view.ui.map
{
	import com.greensock.TweenMax;
	
	import deck.lnc.model.vo.map.LocationVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Location extends Sprite
	{
		public var xPosition:Number;
		public var yPosition:Number;
		
		public var originalWidth:Number;
		public var originalHeight:Number;
		
		public var dashboardPath:String;
		
		private var graphic:MovieClip;
		private var index:uint;
		
		private var data:LocationVO;
		
		private var overed:Boolean = false;
		
		public static const LOCATION_MOUSEOVER_GROW_PERCENT:Number = 1.5;
		
		public static const OUT_ANIMATION_COMPLETE:String = "outAnimationComplete";
		
		public function Location()
		{
			super();
			
			mouseChildren = false;
			
			init();
		}
		
		public function init():void {
			
		}
		
		public function set dataProvider(lvo:LocationVO):void {
			data = lvo;
		}
		
		public function get dataProvider():LocationVO {
			return data;
		}
		
		public function setLocationGraphic(_graphic:MovieClip):void {
			//trace("set graphic " + _graphic);
			graphic = _graphic;
			
			addChild(graphic);
		}
		
		public function setIndex(_index:uint):void {
			index = _index;
		}
		
		public function getIndex():uint {
			return index;
		}
		
		public function isOvered():Boolean {
			return overed;
		}
		
		public function over():void {
			//need some kind of rollover effect
			
			overed = true;
			
			//perhaps growing a bit and a glow?
			if(graphic) {
				TweenMax.to(graphic, .5, {scaleX:LOCATION_MOUSEOVER_GROW_PERCENT, scaleY:LOCATION_MOUSEOVER_GROW_PERCENT});
			}
		}
		
		public function out():void {
			
			overed = false;
			
			if(graphic) {
				TweenMax.to(graphic, .5, {scaleX:1, scaleY:1, onComplete:outAnimationComplete});
			}
		}
		
		private function outAnimationComplete():void {
			dispatchEvent(new Event(OUT_ANIMATION_COMPLETE));
		}
	}
}