package deck.lnc.model
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.twitter.TweetVO;
	import deck.lnc.model.vo.twitter.TwitterVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class TwitterProxy extends Proxy implements IProxy
	{
		private var tweetsLoader:URLLoader;
		private var tweetsPath:String = "http://twitter.com/statuses/user_timeline.xml?screen_name=lewisandclark";
		private var tweetsXML:XML;
		
		private var twitterVO:TwitterVO;
		
		
		public static const NAME:String = "TwitterProxy";
		
		public function TwitterProxy(data:Object=null)
		{
			super(proxyName, data);
			
			init();
		}
		
		private function init():void {
			
			twitterVO = new TwitterVO();
			
			//load tweets
			loadTweets();
		}
		
		private function loadTweets():void {
			tweetsLoader = new URLLoader();
			tweetsLoader.addEventListener(Event.COMPLETE, tweetsLoaded);
			tweetsLoader.addEventListener(IOErrorEvent.IO_ERROR, tweetsIOError);
			tweetsLoader.load(new URLRequest(tweetsPath));
		}
		
		private function tweetsLoaded(e:Event):void {
			//trace("tweets xml " + e.target.data);
			tweetsXML = XML(e.target.data);
			
			twitterVO = getTwitterVO(tweetsXML);
			
			broadcastData();
			
		}
		
		private function getTwitterVO(xml:XML): TwitterVO {
			var statusesLength:uint = xml.status.length();
			//trace("statuses " + statusesLength);
			for(var i:uint = 0; i < statusesLength; i++) {
				//trace("status " + i + " " + tweetsXML.status[i].text);
				//trace("date " + tweetsXML.status[i].created_at);
				//trace("location " + tweetsXML.status[i].user.location);
				//trace("profile_image_url " + tweetsXML.status[i].user.profile_image_url);
				
				twitterVO.tweets.push(getTweetVO(xml.status[i]));
				
			}
			
			//set user icon path
			twitterVO.userIconPath = xml.status[0].user.profile_image_url
			
			return twitterVO;
		}
		
		private function getTweetVO(_xml:XML):TweetVO {
			var t:TweetVO = new TweetVO();
		
			t.text = _xml.text; 
			
			return t;
		}
		
		private function tweetsIOError(ioe:IOErrorEvent):void {
			trace("tweets ioe " + ioe.toString());
		}
		
		private function pingTweets():void {
			//grab the tweets
			//try to do something clever by figuring out if the last tweet has a different
			//update time than the last tweet we already have
			//if it's changed then repopulate the tweets and start the loop over
			//stop tweet timer, load, on load restart tweet timer
		}
		
		private function broadcastData():void {
			trace("TwitterProxy::broadcastData");
			sendNotification(ApplicationFacade.TWITTER_DATA_READY, twitterVO);
		}
	}
}