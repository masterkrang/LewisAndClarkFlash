package deck.lnc.model.vo.twitter
{
	public class TwitterVO
	{
		public var userIconPath:String;
		public var tweets:Vector.<TweetVO>;
		public function TwitterVO()
		{
			init();
		}
		
		public function init():void {
			tweets = new Vector.<TweetVO>();
		}
	}
}