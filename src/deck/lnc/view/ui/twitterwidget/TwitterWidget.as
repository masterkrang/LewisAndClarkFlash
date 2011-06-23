package deck.lnc.view.ui.twitterwidget
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import deck.lnc.model.vo.twitter.TwitterVO;
	import deck.lnc.view.ui.buttons.CloseButton;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class TwitterWidget extends Sprite
	{
		public var tweets:Vector.<Tweet>;
		private var singleTweetBG:Sprite;
		private var multiTweetBG:Sprite;
		public var bg:Sprite;
		//public var stageHeight:Number;
		//public var stageWidth:Number;
		public var _width:Number;
		public var _height:Number;
		
		public var _open:Boolean = false;
		
		public var closeButton:CloseButton;
		
		private static const MAX_TWEETS:uint = 20; // ?
		
		public static const MINIMIZE:String = "minimize";
		public static const MAXIMIZE:String = "maximize";
		public static const TWEET_SHOW:String = "tweetShow";
		public static const TWEET_HIDE:String = "tweetHide";
		
		
		private var tweetShowing:Boolean = false;
		private var currentIndex:uint = 0; //keeps track of what tweet should be showing
		
		//tweet timer
		private var tweetTimer:Timer;
		private var tweetDuration:uint = 6000;
		
		//user icon
		private var userIconLoader:Loader;
		private static const USER_ICON_WIDTH:Number = 48;
		private static const USER_ICON_HEIGHT:Number = 48;
		
		public function TwitterWidget(w:Number = 500, h:Number = 48)
		{
			//should probably control it's own width / height
			//set w h
			setSize(w, h);
			
			init();
		}
		
		public function init():void {
			tweets = new Vector.<Tweet>();
			
			tweetTimer = new Timer(tweetDuration);
			tweetTimer.addEventListener(TimerEvent.TIMER, tweetTimerTick);
			
			draw();
		}
		
		public function set dataProvider(twitterVO:TwitterVO):void {
			
			trace("TwitterWidget::dataProvider");
			loadUserIcon(twitterVO.userIconPath);
			
			//let daddy know the kids are ready to play
			
			tweets = getTweets(twitterVO);
			
			//add the first tweet
			tweets[currentIndex].x = USER_ICON_WIDTH + 5;
			tweets[currentIndex].y = 5;
			addChild(tweets[currentIndex]);
			
			//show it
			showTweet();
			
			//dispatchEvent(new Event(TWEET_SHOW));
			tweetTimer.start();
		}
		
		private function getTweets(tvo:TwitterVO):Vector.<Tweet> {
			var tweetsVector:Vector.<Tweet> = new Vector.<Tweet>();
			
			var tlen:uint = tvo.tweets.length;
			
			for (var i:uint = 0; i < tlen; i++) {
				var t:Tweet = new Tweet();
				t.dataProvider = tvo.tweets[i];
				tweetsVector.push(t);
			}
			
			return tweetsVector;
		}
		
		/*
		private function loadTweets():void {
			tweetsLoader = new URLLoader();
			tweetsLoader.addEventListener(Event.COMPLETE, tweetsLoaded);
			tweetsLoader.addEventListener(IOErrorEvent.IO_ERROR, tweetsIOError);
			tweetsLoader.load(new URLRequest(tweetsPath));
		}
		
		private function pingTweets():void {
			//grab the tweets
			//try to do something clever by figuring out if the last tweet has a different
			//update time than the last tweet we already have
			//if it's changed then repopulate the tweets and start the loop over
			//stop tweet timer, load, on load restart tweet timer
		}
		
		private function tweetsLoaded(e:Event):void {
			//trace("tweets xml " + e.target.data);
			tweetsXML = XML(e.target.data);
			var statusesLength:uint = tweetsXML.status.length();
			//trace("statuses " + statusesLength);
			for(var i:uint = 0; i < statusesLength; i++) {
				//trace("status " + i + " " + tweetsXML.status[i].text);
				//trace("date " + tweetsXML.status[i].created_at);
				//trace("location " + tweetsXML.status[i].user.location);
				//trace("profile_image_url " + tweetsXML.status[i].user.profile_image_url);
				
				tweets.push(getTweetVO(tweetsXML.status[i]));
			}
			
			//load the user icon for
			loadUserIcon(tweetsXML.status[0].user.profile_image_url);
			
			//let daddy know the kids are ready to play
			
			//add the first tweet
			tweets[currentIndex].x = USER_ICON_WIDTH + 5;
			tweets[currentIndex].y = 5;
			addChild(tweets[currentIndex]);
			
			//show it
			showTweet();
			
			//dispatchEvent(new Event(TWEET_SHOW));
			tweetTimer.start();
		}
		*/
		private function loadUserIcon(path:String):void {
			userIconLoader = new Loader();
			//userIconLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, use);
			userIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, userIconLoaded);
			userIconLoader.load(new URLRequest(path));
		}
		
		private function userIconLoaded(e:Event):void {
			trace("user icon width / height " + userIconLoader.width + " / " + userIconLoader.height);
			addChild(userIconLoader);
		}
		
		// a series of events happen for hiding and showing a tweet
		
		private function tweetTimerTick(te:TimerEvent):void {
			//trace("TwitterWidget::tweetTimer");
			//switch for hiding and showing
			/*
			if(tweetShowing) {
				hideTweet();
			} else {
				showTweet();
			}
			*/
			
			//hide
			hideTweet();
			//swap tweet
			
			//show
		}
		
		private function hideTweet():void {
			
			tweetShowing = false;
			//dispatch to parent that the tweet is ready to animate out
			dispatchEvent(new Event(TWEET_HIDE));
			
			//after tweet is hidden fire a callback to swap out to the next tweet
			TweenMax.to(tweets[currentIndex], .5, {alpha:0, onComplete:swapTweet});
			//then another callback to show the tweet again
		}
		
		public function setWidth(w:Number):void {
			bg.width = w;
		}
		
		private function swapTweet():void {
			//remove the old tweet
			removeChild(tweets[currentIndex]);
			//increment the tweet
			var newIndex:uint = currentIndex + 1;
			//check for last
			if(newIndex > tweets.length - 1) {
				newIndex = 0; // set back to first
			}
			
			setCurrentIndex(newIndex);
			
			//set position
			tweets[currentIndex].x = USER_ICON_WIDTH + 5;
			tweets[currentIndex].y = 5;
			
			addChild(tweets[currentIndex]);
			//ready to show
			showTweet();
		}
		
		private function showTweet():void {
			tweetShowing = true;
			
			dispatchEvent(new Event(TWEET_SHOW));
			
			TweenMax.to(tweets[currentIndex], .5, {alpha:1});
		}
		
		/*
		private function getTweetVO(_xml:XML):Tweet {
			var t:Tweet = new Tweet();
			t.dataProvider = _xml;
			//t.text = _xml.text;
			return t;
		}
		
		private function tweetsIOError(ioe:IOErrorEvent):void {
			trace("tweets ioe " + ioe.toString());
		}
		*/
		private function draw():void {
			drawBG();
			drawCloseButton();
		}
		
		public function getCurrentIndex():uint {
			return currentIndex;
		}
		
		private function setCurrentIndex(_index:uint):void {
			currentIndex = _index;
		}
		
		private function drawCloseButton():void {
			closeButton = new CloseButton();
			closeButton.x = 450;
			closeButton.y = 10;
			
			//closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);
			closeButton.addEventListener(CloseButton.MINIMIZE_CLICK, minimize);
			closeButton.addEventListener(CloseButton.MAXIMIZE_CLICK, maximize);
			
			//hide close button until the all the tweets are showing?
			closeButton.alpha = .2;
			
			addChild(closeButton);
		}
		
		private function minimize(e:Event):void {
			dispatchEvent(new Event(MINIMIZE));
		}
		
		private function maximize(e:Event):void {
			dispatchEvent(new Event(MAXIMIZE));
		}
		
		private function revealTweets():void {
			//iterate through tweets and reveal them
			var tlen:uint = tweets.length;
			for (var i:uint = 0; i < tlen; i++) {
				tweets[i].show();
			}
		}
		
		public function closeButtonClick(me:MouseEvent):void {
			
		}
		
		public function isOpen():Boolean {
			return _open;
		}
		
		public function open():void {
			_open = true;
		}
		
		public function close():void {
			_open = false;
		}
		
		private function setSize(w:Number, h:Number):void {
			//stageWidth = sw;
			//stageHeight = sh;
			
			_width = w;
			_height = h;
			
			//reset bg
			if(bg) {
				bg.width = w;			
				bg.height = h;
			}
		}
		
		private function drawBG():void {
			bg = new Sprite();
			bg.graphics.beginFill(0x000000, .5);
			bg.graphics.drawRect(0, 0, _width, _height);//stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			addChild(bg);
		}
		
		public function resize(w:Number, h:Number):void {
			//do all the resize stuff here
			//setSize(w, h);
		}
	}
}