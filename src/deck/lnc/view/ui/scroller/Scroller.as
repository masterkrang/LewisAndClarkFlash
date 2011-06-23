package deck.lnc.view.ui.scroller
{
	import deck.lnc.view.ui.scroller.bar.Bar;
	
	import flash.display.Sprite;
	
	public class Scroller extends Sprite
	{
		public var bar:Bar;
		public var content:Sprite;
		
		public function Scroller()
		{
			super();
			init();
		}
		
		public function init():void {
			
			bar = new Bar();
			
			draw();
		}
		
		public function set source(_content:Sprite):void {
			content = _content;
			
			//get the content w / h and set the set the width and height
		}
		
		public function draw():void {
			
		}
		
		public function setHeight(h:Number):void {
			
			bar.setHeight(h);
		}
		
		public function setWidth(w:Number):void {
			bar.setWidth(w);
		}
	}
}