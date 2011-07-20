package deck.lnc.view.ui.map
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.kurt.util.LayoutFactory;
	
	public class Key extends Sprite
	{
		private var bg:Sprite;
		private var keyContents:KeyAsset;
		
		public function Key()
		{
			super();
			init();
		}
		
		private function init():void {
			
			keyContents = new KeyAsset();
			
			//size key asset in proportion
			
			draw();
			addListeners();
		}
		
		private function addListeners():void {
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(me:MouseEvent):void {
			//TweenMax.to(bg, 1, {alpha:1});
		}
		
		private function onMouseOut(me:MouseEvent):void {
			//TweenMax.to(bg, 1, {alpha:.3});
		}
		
		public function resize(w:Number, h:Number):void {
			setHeight(h);
			setWidth(w);
			
			//resize key
			LayoutFactory.resizeMe(keyContents, w, h)
			keyContents.x = 0;
			keyContents.y = 0;
		}
		
		public function setHeight(h:Number):void {
			bg.height = h;
		}
		
		public function setWidth(w:Number):void {
			bg.width = w;
		}
		
		private function draw():void {
			bg = new Sprite();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0,0,270, 350);
			bg.graphics.endFill();
			bg.alpha = .7;
			addChild(bg);
			
			addChild(keyContents);
		}
	}
}