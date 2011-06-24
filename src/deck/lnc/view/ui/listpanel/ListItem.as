package deck.lnc.view.ui.listpanel
{
	import com.kurt.util.TextFormatFactory;
	
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.model.vo.map.MapVO;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	public class ListItem extends Sprite
	{
		private var bg:Sprite;
		private var bgOver:Sprite;
		private var bgSelected:Sprite;
		//private var bgClicked:Sprite;
		
		private var tf:TextField;
		private var data:Object;
		
		public var index:uint;
		
		public static const WIDTH:Number = 200;
		public static const HEIGHT:Number = 25;
		public static const TWO_LINE_HEIGHT:Number = 50;
		public static const MARGIN_LEFT:Number = 5;
		
		//dispatch events
		public static const CLICK:String = "listItemClick";
		public static const OVER:String = "listItemOver";
		public static const OUT:String = "listItemOut";
		
		private var selected:Boolean = false;
		
		private var locationVO:LocationVO;		

		public function ListItem()
		{
			//trace("ListItem");
			super();
			
			init();
		}
		
		private function init():void {
			
			//mapVO = new MapVO();
			
			tf = new TextField();
			tf.defaultTextFormat = TextFormatFactory.getListItemFormat();
			TextFormatFactory.setTextParams(tf);
			
			bg = new Sprite();
			bgOver = new Sprite();
			bgSelected = new Sprite();
			//bgClicked = new Sprite();
			
			//mouseChildren = false;
		}
		
		public function set dataProvider(_locationVO:LocationVO):void {
			
			locationVO = _locationVO;
			//trace("ListItem data.name " + locationVO.title);
			//set text etc
			tf.width = WIDTH - MARGIN_LEFT;
			
			//trace("HEIGHT " + HEIGHT + " tf.height " + tf.height);
			tf.htmlText = locationVO.title; //"sample text"; //_data.name;
			
			if(tf.numLines > 1) {
				tf.y = TWO_LINE_HEIGHT / 2 - tf.height / 2;
			} else {
				tf.y = HEIGHT / 2 - tf.height / 2;
			}
			
			tf.x = MARGIN_LEFT;
			
			trace("tf.numLines " + tf.numLines);
			
			draw();
		}
		
		public function getNumLines():int {
			return tf.numLines;
		}
		
		private function draw():void {
			drawBG();
			drawBGOver();
			drawBGSelected();
			//drawBGClicked();
			
			//
			bgOver.visible = false;
			bgSelected.visible = false;
			//bgClicked.visible = false;
			
			addChildren();
			
			addListeners();
		}
		
		private function addListeners():void {
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function addChildren():void {
			addChild(tf);
		}
		
		private function onClick(me:MouseEvent):void {
			trace("ListItem click");
			
			//change the color of bg
			
			if(getSelected()) {
				
			} else {
				select();
			}
			
			dispatchEvent(new Event(CLICK));
		}
		
		private function onOver(me:MouseEvent):void {
			//trace("ListItem over");
			
			//trace("over mouseX " + mouseX + " mouseY " + mouseY);
			if(getSelected()) {
				
			} else {
				bgOver.visible = true;
				bgSelected.visible = false;
				bg.visible = false;
				//bgClicked.visible = false;
				tf.textColor = 0x000000;
			}
			
			dispatchEvent(new Event(OVER));
		}
		
		public function getSelected():Boolean {
			return selected;
		}
		
		private function onOut(me:MouseEvent):void {
			//trace("ListItem out");
			
			if(getSelected()) {
				
			} else {
				bgOver.visible = false;
				bgSelected.visible = false;
				bg.visible = true;
			}
			
			selected = false;
			
			dispatchEvent(new Event(OUT));
		}
		
		public function deselect():void {
			trace("deselect called");
			bgOver.visible = false;
			bgSelected.visible = false;
			bg.visible = true;
			//bgClicked.visible = true;
			tf.textColor = 0x000000;
			selected = false;
		}
		
		public function select():void {
			trace("select called");
			bgOver.visible = false;
			bgSelected.visible = true;
			bg.visible = false;
			//bgClicked.visible = true;
			tf.textColor = 0xFFFFFF;
			selected = true;
		}
		
		public function drawBG():void {
			var _height:Number;
			if(tf.numLines > 1) {
				_height = TWO_LINE_HEIGHT
			} else {
				_height = HEIGHT;
			}
			var colors:Array = [0xCCCCCC, 0xDDDDDD];
			var alphas:Array = [.5, .5];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(WIDTH, _height, Math.PI / 2);
			bg.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			bg.graphics.drawRect(0, 0, WIDTH, _height);
			bg.graphics.endFill();
			addChild(bg);
		}
		
		private function drawBGOver():void {
			var _height:Number;
			if(tf.numLines > 1) {
				_height = TWO_LINE_HEIGHT
			} else {
				_height = HEIGHT;
			}
			var colors:Array = [0xAAAAAA, 0xDDDDDD];
			var alphas:Array = [.5, .5];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(WIDTH, _height, Math.PI / 2);
			bgOver.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			bgOver.graphics.drawRect(0, 0, WIDTH, _height);
			bgOver.graphics.endFill();
			addChild(bgOver);
		}
		
		private function drawBGSelected():void {
			var _height:Number;
			if(tf.numLines > 1) {
				_height = TWO_LINE_HEIGHT
			} else {
				_height = HEIGHT;
			}
			var colors:Array = [0x000000, 0x333333];
			var alphas:Array = [.9, .9];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(WIDTH, _height, Math.PI / 2);
			bgSelected.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			bgSelected.graphics.drawRect(0, 0, WIDTH, _height);
			bgSelected.graphics.endFill();
			addChild(bgSelected);
		}
	}
}