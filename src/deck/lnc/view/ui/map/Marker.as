package deck.lnc.view.ui.map
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	
	public class Marker extends Sprite
	{
		public var xPosition:Number;
		public var yPosition:Number;
		public var location:String;
		public var building:String;
		public var title:String;
		public var description:String;
		
		public var originalHeight:Number;
		public var originalWidth:Number;
		
		private var marker:DashboardMarker;
		
		//event strings
		public static const MARKER_OUT:String = "markerOut";
		public static const MARKER_OVER:String = "markerOver";
		
		public function Marker()
		{
			super();
			trace("new Marker");
			init();
			//drawMarker();
		}
		
		private function init():void {
			
			
			//buttonMode = true;
			//useHandCursor = true;
			
			marker = new DashboardMarker();
			
			originalHeight = marker.height;
			originalWidth = marker.width;
			
			drawMarker();
			
			addListeners();
		}
		
		public function drawMarker():void {
			
			addChild(marker);
			/*
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x0000FF);
			s.graphics.drawCircle(0,0,20);
			s.graphics.endFill();
			trace("add marker");
			addChild(s);
			*/
		}
		
		private function addListeners():void {
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(me:MouseEvent):void {
			trace("Marker::onMouseClick");
		}
		
		private function onMouseOver(me:MouseEvent):void {
			trace("Marker::onMouseOver");
			dispatchEvent(new Event(MARKER_OVER));
			TweenMax.to(marker, .5, {scaleX:5, scaleY:5});
		}
		
		private function onMouseOut(me:MouseEvent):void {
			trace("Marker::onMouseOut");
			dispatchEvent(new Event(MARKER_OUT));
			TweenMax.to(marker, .5, {width:originalWidth, height:originalHeight});
		}
	}
}