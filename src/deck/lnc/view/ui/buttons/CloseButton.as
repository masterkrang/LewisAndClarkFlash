package deck.lnc.view.ui.buttons
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CloseButton extends Sprite
	{
		public var _open:Boolean = false;
		public var openButton:Sprite;
		public var closeButton:Sprite;
		
		public static const MINIMIZE_CLICK:String = "minimizeClick";
		public static const MAXIMIZE_CLICK:String = "maximizeClick";
		
		public function CloseButton()
		{
			super();
			
			init();
		}
		
		private function init():void {
			draw();
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(me:MouseEvent):void {
			if(_open) {
				closeButton.visible = true;
				openButton.visible = false;
				_open = false;
				
				dispatchEvent(new Event(MINIMIZE_CLICK));
			} else {
				closeButton.visible = true;
				openButton.visible = false;
				_open = true;
				
				dispatchEvent(new Event(MAXIMIZE_CLICK));
			}
		}
		
		private function draw():void {
			openButton = drawSquare(0x333333);
			closeButton = drawSquare(0x000000);
			
			addChild(openButton);
			addChild(closeButton);
		}
		
		private function drawSquare(_color:int):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(_color);
			s.graphics.drawRect(0, 0, 20, 20);
			s.graphics.endFill();
			return s;
		}
	}
}