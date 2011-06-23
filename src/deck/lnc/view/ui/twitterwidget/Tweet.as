package deck.lnc.view.ui.twitterwidget
{
	import deck.lnc.model.vo.twitter.TweetVO;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import com.kurt.util.TextFormatFactory;
	
	public class Tweet extends Sprite
	{
		public var text:TextField;
		public var createdAt:String;
		public var location:String;
		public var bg:Sprite;
		public var index:uint;
	
		//public var tweet
		public function Tweet()
		{
			super();
			init();
		}
		
		public function init():void {
			bg = new Sprite();
			text = new TextField();
			text.defaultTextFormat = TextFormatFactory.getTweetTextFormat();
			TextFormatFactory.setTextParams(text);
			
			//TextFormatFactory
			text.width = 450;
			draw();
		}
		
		public function draw():void {
			//draw bg
			addChild(bg);
			addChild(text);
		}
		
		public function set dataProvider(tweetVO:TweetVO):void {
			text.text = tweetVO.text;
		}
		
		public function show():void {
		
		}
		
		public function hide():void {
			
		}
	}
}