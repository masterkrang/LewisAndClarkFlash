package deck.lnc.view.ui.scroller.bar
{
	import flash.display.Sprite;
	
	
	//named Bar because flash sucks (name conflict with internal component)
	public class Bar extends Sprite
	{
		public var _width:Number;
		public var _height:Number;
		public var bar:Sprite;
		
		public function Bar()
		{
			super();
		}
		
		public function init():void {
			
			bar = new Bar();
			
			draw();
		}
		
		public function draw():void {
			
		}
		
		public function setHeight(h:Number):void {
			//set the background height
			_height = h;
		}
		
		public function setWidth(w:Number):void {
			//set the width
			_width = w;
		}
		
		public function setBarPosition(_percent:Number):void {
			bar.y = _height * _percent;
		}
	}
}