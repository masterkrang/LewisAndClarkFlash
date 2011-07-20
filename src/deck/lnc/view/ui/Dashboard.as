package deck.lnc.view.ui
{
	import com.greensock.TweenMax;
	
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.view.ui.buttons.CloseButton;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	
	public class Dashboard extends Sprite
	{
		public static const WIDTH:Number = 550;
		public static const HEIGHT:Number = 400;
		
		private var dashboardLoader:Loader;
		private var data:LocationVO;
		
		private var bg:Sprite;
		
		private var closeButton:CloseButtonAsset;
		//private var urlRequest:URLRequest;
		//private var scrim:
		
		public static const CLOSE_CLICK:String = "closeClick";
		
		public function Dashboard()
		{
			super();
			//init();
			
			draw();
		}
		
		private function draw():void {
			
			closeButton = new CloseButtonAsset();
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);
			
			drawBG();
			
			closeButton.x = WIDTH;
			closeButton.y = 0;
			
			//addChild(closeButton);
			addFilters();
		}
		
		public function addFilters(_filters:Array = null):void {
			var dsf:DropShadowFilter = new DropShadowFilter(10.0, 45, 0, .5, 10.0, 10.0);
			this.filters = [dsf];
		}
		
		private function drawBG():void {
			bg = new Sprite();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0,0,WIDTH,HEIGHT);
			bg.graphics.endFill();
			addChild(bg);
		}
		
		private function init():void {
			trace("dashboard init");
			if(dashboardLoader) {
				//then destroy it and it's listeners
				cleanUp();
			}
			
			dashboardLoader = new Loader();
			dashboardLoader.alpha = 0;
			dashboardLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, dashboardLoaded);
			dashboardLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, dashboardLoadProgress);
			dashboardLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, dashboardIOError);
			trace("dashboard load " + data.dashboardPath);
			dashboardLoader.load(new URLRequest(data.dashboardPath));
		}
		
		private function dashboardLoaded(e:Event):void {
			trace("dashboard loaded");
			removeEventListener(Event.COMPLETE, dashboardLoaded);
			removeEventListener(ProgressEvent.PROGRESS, dashboardLoadProgress);
			//get rid of listeners
			
			addChild(dashboardLoader);
			TweenMax.to(dashboardLoader, .5, {alpha:1});
			
			//add and show close button
			addChild(closeButton);
			TweenMax.to(closeButton, .2, {delay:.5, alpha:1});
		}
		
		private function dashboardLoadProgress(pe:ProgressEvent):void {
			trace("dashboard load progress");
		}
		
		private function dashboardIOError(ioe:IOErrorEvent):void {
			trace("dashboard IOERROR " + ioe.toString());
		}
		
		public function set dataProvider(_data:LocationVO):void {
			/*
			//set the source
			urlRequest = new URLRequest(data.path);
			//load the dashboard
			dashboardLoader.load(urlRequest);
			*/
			
			data = _data;
			
			init();
		}
		
		public function closeButtonClick(me:MouseEvent):void {
			trace("close button click");
			dispatchEvent(new Event(CLOSE_CLICK));
		}
		
		public function cleanUp():void {
			//need to get rid of listeners and memory leaks
			if(contains(dashboardLoader)) {
				removeChild(dashboardLoader);
			}
			
			dashboardLoader = null;
			
			if(hasEventListener(Event.COMPLETE)) {
				removeEventListener(Event.COMPLETE, dashboardLoaded);
			}
			if(hasEventListener(ProgressEvent.PROGRESS)) {
				removeEventListener(ProgressEvent.PROGRESS, dashboardLoadProgress);
			}
			
			//destroy swf, do the swf's have clean methods?
		}
		
		
	}
}