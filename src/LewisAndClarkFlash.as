package
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.kurt.util.LayoutFactory;
	import com.kurt.view.Scrim;
	
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.view.ui.Dashboard;
	import deck.lnc.view.ui.listpanel.ListItem;
	import deck.lnc.view.ui.listpanel.ListPanel;
	import deck.lnc.view.ui.map.Key;
	import deck.lnc.view.ui.map.Location;
	import deck.lnc.view.ui.map.LocationMetadata;
	import deck.lnc.view.ui.map.Map;
	import deck.lnc.view.ui.map.Marker;
	import deck.lnc.view.ui.scroller.Scroller;
	import deck.lnc.view.ui.stats.StatsPanel;
	import deck.lnc.view.ui.twitterwidget.TwitterWidget;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.patterns.facade.*;
	
	public class LewisAndClarkFlash extends Sprite
	{	
		//these config params should all be placed in the map xml for easy modifications
		public static const TRAY_HEIGHT:Number = 53;
		public static const LEFT_PANEL_WIDTH:Number = ListItem.WIDTH;
		public static const LIST_PANEL_SCROLLBAR_WIDTH:Number = ListPanel.SCROLLBAR_WIDTH;
		
		//puremvc
		public var facade:ApplicationFacade;
		
		//map
		public var map:Map;
		public var mapLoaded:Boolean = false;
		public static const ZOOM_IN_TIME:Number = .6;
		public static const ZOOM_OUT_TIME:Number = .6;
		
		//key
		public var key:Key;
		private const KEY_MARGIN_RIGHT:Number = 10;
		private const KEY_MARGIN_BOTTOM:Number = 10;
		
		//list
		public var list:ListPanel;
		
		//stats
		public var stats:StatsPanel;
		
		//dashboard
		public var dashboard:Dashboard;
		public static const DASHBOARD_SHOW_TIME:Number = .2;
		public static const DASHBOARD_HIDE_TIME:Number = .2;
		public var dashboardOpen:Boolean = false;
		
		//twitter widget at bottom
		public var twitterWidget:TwitterWidget;
		
		//scrim (a transparent layer for fading out other views and laying selected views on top of)
		public var scrim:Scrim;
		public static const SCRIM_ALPHA:Number = .65;
		public static const SCRIM_SHOW_TIME:Number = .2;
		public static const SCRIM_HIDE_TIME:Number = .2;
		
		//location metadata
		public var locationMetadata:LocationMetadata;
		public var locationMetadataShowing:Boolean = false;
		
		public function LewisAndClarkFlash()
		{
			init();
			//addChild(new MapVector());
			//addChild(new LocationMetadataBG());
			//addChild(new MapVector());
			
			//var l:LocationMetadataBG = new LocationMetadataBG();
			//l.x = 100;
			//l.y = 100;
			//addChild(l);
		}
		
		public function init():void {
		
			//create objects
			createTwitterWidget();
			
			createMap();
			//load map
			//loadMap();
			//addChild(map)
			//mapLoaded();
			
			key = new Key();
			
			list = new ListPanel();
			
			stats = new StatsPanel();
			
			dashboard = new Dashboard();
			dashboard.addEventListener(Dashboard.CLOSE_CLICK, dashboardCloseClick);
			
			scrim = new Scrim(0x000000, stage.stageWidth, stage.stageHeight);
			scrim.addEventListener(MouseEvent.CLICK, scrimClick);
			
			locationMetadata = new LocationMetadata();
			locationMetadata.addEventListener(LocationMetadata.DASHBOARD_LINK_CLICK, locationMetadataDashboardLinkClick);
			locationMetadata.addEventListener(LocationMetadata.METADATA_CLOSE, locationMetadataCloseClick);
			locationMetadata.addEventListener(LocationMetadata.HIDE_COMPLETE, locationMetadataHideComplete);
			
			setStageProperties();
			
			addListeners();
			
			//stack 
			addChildren();
		}
		
		/******************* CREATE OBJECTS **************/
		
		private function createTwitterWidget():void {
			//trace("stage w / h " + stage.stageWidth + " / " + stage.stageHeight);
			twitterWidget = new TwitterWidget(stage.stageWidth, TRAY_HEIGHT);
			//trace("stage.stageWidth / 2 - twitterWidget.width / 2 " + (stage.stageWidth / 2 - twitterWidget.width / 2));
			twitterWidget.x = stage.stageWidth / 2 - twitterWidget.width / 2;
			twitterWidget.y = stage.stageHeight;// - TRAY_HEIGHT;
			//twitterWidget.addEventListener(MouseEvent.CLICK, twitterWidgetOpenClick);
			twitterWidget.addEventListener(TwitterWidget.MINIMIZE, twitterWidgetMinimize);
			twitterWidget.addEventListener(TwitterWidget.MAXIMIZE, twitterWidgetMaximize);
			twitterWidget.addEventListener(TwitterWidget.TWEET_SHOW, tweetShow);
			twitterWidget.addEventListener(TwitterWidget.TWEET_HIDE, tweetHide);
		}
		
		private function createMap():void {
			map = new Map();
			map.addEventListener(Map.MAP_LOAD_COMPLETE, mapLoadComplete);
			//map.addEventListener(Map.MARKER_CLICK, mapMarkerClick);
		}
		
		/****************************************************/
		
		private function addChildren():void {
			
			//stack order
			addChild(map);
			addChild(key);
			addChild(twitterWidget);
			addChild(list);
			
			addChild(new LocationMetadataBG());
			//add Dashboard only on location click events
		}
		
		private function mapLoadComplete(e:Event = null):void {
			
			
			trace("add map");
			
			mapLoaded = true;
			
			map.alpha = 0;
			
			//scale it to fit
			onResize();
			
			//fade it in
			TweenMax.to(map, 1, {alpha:1});
			
			addChild(map);
			
			
			
			//stack
			
			//add list
			addChild(list);
			
			//add key
			addChild(key);
			
			//add twitter widget
			addChild(twitterWidget);
			
			
		}
		
		private function addListeners():void {
			stage.addEventListener(Event.RESIZE, onResize);
			
			//fake resize event
			stage.dispatchEvent(new Event(Event.RESIZE));
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			//fire up puremvc
			facade = ApplicationFacade.getInstance();
			facade.startup(this);
		}
		
		private function onResize(e:Event = null):void {
			
			//vars
			var sw:Number = stage.stageWidth;
			var sh:Number = stage.stageHeight
			
			//trace("-------------");
			//trace("stage resize event\nstagewidth = " + stage.stageWidth + " stageheight = " + stage.stageHeight);
			//perhaps bubble event through puremvc to the concerned views with new stage size
			
			//resize twitter widget
			
			//trace("stagewidth / 2 - twitterWidget.width / 2 " + (stage.stageWidth / 2 - twitterWidget.width / 2));
			//var toX:Number = sw / 2 - twitterWidget.width / 2;
			//TweenLite.to(twitterWidget, 1, {x:toX});
			//twitterWidget.x = toX;
			//trace("tox " + toX);
			
			twitterWidget.setWidth(stage.stageWidth);
			
			var toY:Number;// = stage.stageHeight - TRAY_HEIGHT;
		
			if(twitterWidget.isOpen()) {
				toY = sh / 2 - twitterWidget.height / 2;
				//TweenLite.to(twitterWidget, 1, {y:toY, x:toX});
				twitterWidget.y = toY;
			} else {
				//place in the tray
				toY = sh - TRAY_HEIGHT;
				//TweenLite.to(twitterWidget, 1, {y:toY, x:toX});
				twitterWidget.y = toY;
			}
			
			
			//resize map
			//snapFit(map);
			
			if(mapLoaded) {
				//need to wait till it's loaded before scaling and showing
				var mapAreaHeight:Number = getMapAreaHeight();
				var mapAreaWidth:Number = getMapAreaWidth();
				
				LayoutFactory.resizeMe(map, mapAreaWidth, mapAreaHeight, true);
				
				map.x = LEFT_PANEL_WIDTH + (mapAreaWidth / 2 - map.width / 2);
				//map.x = LEFT_PANEL_WIDTH;
				map.y = mapAreaHeight / 2 - map.height / 2;
			}
			
			
			//list
			var stageHeightMinusWidgetHalfed:Number = (sh - twitterWidget.height) / 2;
			
			list.setHeight(stageHeightMinusWidgetHalfed);
			
			//key
			//place key in left bottom corner based on shape of map
			//key.x = 10;
			key.y = stageHeightMinusWidgetHalfed; //(sh - key.height) - 10;
			//key.setWidth(LEFT_PANEL_WIDTH);
			//key.setHeight(stageHeightMinusWidgetHalfed);
			key.resize(LEFT_PANEL_WIDTH + LIST_PANEL_SCROLLBAR_WIDTH, stageHeightMinusWidgetHalfed);
			
			//scrim
			scrim.resize(sw, sh);
			
			//dashboard
			if(dashboardOpen) {
				dashboard.x = sw / 2 - dashboard.width / 2;
				dashboard.y = sh / 2 - dashboard.height / 2;
			}
		}
		
		
		
		private function resizeIt(o:Object, percent:Number):void {
			o.scaleX = o.scaleY = percent;
			//now center the image within the stage
			centerIt(o);
		}
		
		private function centerIt(o:Object):void {
			o.x = stage.stageWidth / 2 - o.width / 2;
			//o.y = stage.stageHeight / 2 - o.height / 2;
		}
		
		private function setStageProperties():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//stage.displayState = StageDisplayState
		}
		
		/************* MAP *********************************/
		
		public function mapLocationClick(loc:Location):void {
			trace("LewisAndClarkFlash::mapLocationClick " + loc.xPosition);
			
			//disable mouse clicks and set map ready for zooming
			//map.mouseEnabled = false;
			//map.disable();
			
			if(locationMetadataShowing) {
				locationMetadata.hide();
			}
			
			zoomInOnLocation(loc);
			
			//init the dashboard
			//dashboard.dataProvider = loc.dataProvider;
		}
		
		private function zoomInOnLocation(loc:Location):void {
			
			//trace("map.scaleX " + map.scaleX + " map.scaleY " + map.scaleY);
			//trace("location.originalWidth " + loc.originalWidth + " location.originalHeight " + loc.originalHeight);
			//trace("location.width " + loc.width + " location.height " + loc.height);
			
			//trace("map area width " + getMapAreaWidth() + " map area height " + getMapAreaHeight());
			//trace("map width " + map.width + " map height " + map.height);
			//trace("map orig width " + map.originalWidth + " height " + map.originalHeight);
			var locationHeightInPixels:Number = loc.originalHeight * map.scaleY;
			var locationWidthInPixels:Number = loc.originalWidth * map.scaleX;
			
			//trace("locationHeightInPixels " + locationHeightInPixels + " locationWidthInPixels " + locationWidthInPixels);
			
			
			var amountPercentMapNeedsToGrow:Number; 
			var s:Sprite = createImpersonatorSprite(locationWidthInPixels, locationHeightInPixels);
			
			//amountPercentMapNeedsToGrow = LayoutFactory.resizeMe(s, getMapAreaWidth(), getMapAreaHeight());//getObjectScaleFactor(s);
			LayoutFactory.resizeMe(s, getMapAreaWidth(), getMapAreaHeight());
			//trace("new fake sprite width / height " + s.width + " / " + s.height);
			
			var resizePercent:Number = (s.width / loc.originalWidth) * .25;//.80; // * .80 don't want to fill the whole screen
			//trace("resize percent " + resizePercent);
			
			//also need to figure out new negative x and y positions for map to tween
			//to give the effect of centering on the location
			
			//figure out new height and width of the map
			
			var newMapHeight:Number = resizePercent * map.originalHeight;
			var newMapWidth:Number = resizePercent * map.originalWidth;
			
			//figure out the percentage of the location x and y
			var locationPointXPercentage:Number = loc.xPosition / map.originalWidth;
			var locationPointYPercentage:Number = loc.yPosition / map.originalHeight;
			
			//calculate how many pixels over the location will be in the new map size
			var newLocationXPosition:Number = newMapWidth * locationPointXPercentage;
			var newLocationYPosition:Number = newMapHeight * locationPointYPercentage;
			
			var newMapNegativeX:Number = newLocationXPosition - (LEFT_PANEL_WIDTH + getMapAreaWidth() / 2);
			var newMapNegativeY:Number = newLocationYPosition - (getMapAreaHeight() / 2);
			
			//trace("amountPercentMapNeedsToGrow " + amountPercentMapNeedsToGrow);
			TweenMax.to(map, ZOOM_IN_TIME, {scaleX:resizePercent, scaleY:resizePercent, x:-newMapNegativeX, y:-newMapNegativeY, onComplete:zoomInOnLocationComplete});
		
			//initDashboard(loc);
			
			//set the location metadata
			locationMetadata.dataProvider = loc.dataProvider;
		}
		
		private function zoomInOnLocationComplete():void {
			//showDashboard();
			
			//show location metadata panel
			showLocationMetadata();
		}
		
		private function zoomOutOfLocation():void {
			
			//remove the scrim layer if it has been added
			if(contains(scrim)) {
				removeChild(scrim);
			}
			
			//need to wait till it's loaded before scaling and showing
			var mapAreaHeight:Number = getMapAreaHeight();
			var mapAreaWidth:Number = getMapAreaWidth();
			
			var fakeMap:Sprite = createImpersonatorSprite(map.originalWidth, map.originalHeight);
			LayoutFactory.resizeMe(fakeMap, mapAreaWidth, mapAreaHeight, true);
			
			
			
			var toX:Number = LEFT_PANEL_WIDTH + (mapAreaWidth / 2 - fakeMap.width / 2);
			//map.x = LEFT_PANEL_WIDTH;
			var toY:Number = mapAreaHeight / 2 - fakeMap.height / 2;
			
			TweenMax.to(map, ZOOM_OUT_TIME, {x:toX, y:toY, scaleX:fakeMap.scaleX, scaleY:fakeMap.scaleY, onComplete:mapZoomOutOfLocationComplete});
		}
		
		private function mapZoomOutOfLocationComplete():void {
			trace("mapZoomOutOfLocationComplete");
			
			//re enable mouse children of map
			map.enable();
		}
		
		private function mapScaleUpComplete():void {
			//dispatch to dashboard to show, probably should be init'd before 
			
		}
		
		private function traceGrownMapSize():void {
			trace("grow map width " + map.width + " height " + map.height);
			trace("map scaleX " + map.scaleX + " map.scaleY " + map.scaleY);
		}
		
		private function getObjectScaleFactor(s:Sprite):Number {
			var fakeSprite:Sprite = createImpersonatorSprite(s.width, s.height);
			var scaleFactor:Number = LayoutFactory.getResizeFactor(fakeSprite, getMapAreaWidth(), getMapAreaHeight());
			
			return scaleFactor;
		}
		
		private function createImpersonatorSprite(w:Number, h:Number):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x000000);
			s.graphics.drawRect(0,0,w,h);
			s.graphics.endFill();
			trace("created fake sprite w / h " + s.width + " / " + s.height);
			return s;
		}
		
		public function getMapAreaWidth():Number {
			var mapAreaWidth:Number = stage.stageWidth - LEFT_PANEL_WIDTH;
			return mapAreaWidth;
		}
		
		public function getMapAreaHeight():Number {
			var mapAreaHeight:Number = stage.stageHeight - TRAY_HEIGHT;
			return mapAreaHeight;
		}
		
		/***************************************************/
		
		/************* LOCATION METADATA *******************/
		
		
		
		public function showLocationMetadata():void {
			//locationMetadata.dataProvider =
			locationMetadataShowing = true;
			trace("showLocationMetadata");
			if(locationMetadata) {
				addChild(locationMetadata);
			}
			//addChild(locationMetadata);
			locationMetadata.x = LEFT_PANEL_WIDTH + getMapAreaWidth() / 2;//center it
			locationMetadata.y = getMapAreaHeight() / 2;
			locationMetadata.show();
		}
		
		public function hideLocationMetadata():void {
			locationMetadataShowing = false;
			locationMetadata.hide();
		}
		
		public function locationMetadataDashboardLinkClick(e:Event):void {
			showDashboard();
		}
		
		public function locationMetadataCloseClick(e:Event):void {
			zoomOutOfLocation();
		}
		
		public function locationMetadataHideComplete(e:Event):void {
			//trace("remove locationmetadata outside");
			if(contains(locationMetadata)) {
				//trace("remove locationMetadata");
				removeChild(locationMetadata);
			}
		}
		
		/***************************************************/
		
		/************* LISTPANEL ***************************/
		
		public function onListPanelClicked(lvo:LocationVO):void {
			//show dashboard
			//addChild(dashboard);
			
		}
		
		/***************************************************/
		
		/************* DASHBOARD ***************************/
		
		/*
		public function openDashboard(lvo:LocationVO):void {
			
		}
		*/
		
		public function dashboardCloseClick(e:Event):void {
			hideDashboard();
		}
		
		public function initDashboard(loc:Location):void {
			dashboard.dataProvider = loc.dataProvider;
		}
		
		public function showDashboard():void {
			//show scrim
			showScrim();
			
			dashboardOpen = true;
		}
		
		public function hideDashboard():void {
			fadeOutDashboard();
			
			
			dashboardOpen = false
		}
		
		private function fadeInDashboard():void {
			//set dashboard x
			dashboard.x = stage.stageWidth / 2 - dashboard.width / 2;
			dashboard.y = stage.stageHeight / 2 - dashboard.height / 2;
			
			trace("dashboard.width " + dashboard.width + " dashboard.height " + dashboard.height);
			
			dashboard.alpha = 0;
			addChild(dashboard);
			
			TweenMax.to(dashboard, DASHBOARD_SHOW_TIME, {autoAlpha:1});
		}
		
		private function fadeOutDashboard():void {
			TweenMax.to(dashboard, DASHBOARD_HIDE_TIME, {autoAlpha:0, onComplete:fadeOutDashboardComplete});
		}
		
		private function fadeOutDashboardComplete():void {
			
			if(contains(dashboard)) {
				removeChild(dashboard);
			}
			
			hideScrim();
		}
		
		/***************************************************/
		
		
		/************* TWITTER WIDGET **********************/
		
		private function tweetShow(e:Event):void {
			//trace("LewisAndClarkFlash::tweetShow");
			//tween the tweet up from bottom
			//var toY:Number = stage.stageHeight - TRAY_HEIGHT
			//TweenMax.to(twitterWidget, .5, {y:toY})
		}
		
		private function tweetHide(e:Event):void {
			//trace("LewisAndClarkFlash::tweetHide");
			//tween the tweet back down	
			//var toY:Number = stage.stageHeight;// - TRAY_HEIGHT
			//TweenMax.to(twitterWidget, .5, {y:toY});
		}
		
		private function twitterWidgetMinimize(e:Event):void {
			//expand the widget 
			var toY:Number = stage.stageHeight - TRAY_HEIGHT; // / 2 - twitterWidget.width / 2;
			TweenLite.to(twitterWidget, 1, {y:toY});
		}
		
		private function twitterWidgetMaximize(e:Event):void {
			//expand the widget 
			var toY:Number = stage.stageHeight / 2 - twitterWidget.width / 2;
			TweenLite.to(twitterWidget, 1, {y:toY});
		}
		/************************************************/
		
		/*************** SCRIM **************************/
		
		private function scrimClick(me:MouseEvent):void {
			if(dashboardOpen) {
				hideDashboard();
			}
		}
		
		private function showScrim():void {
			addChild(scrim);
			TweenMax.to(scrim, .2, {autoAlpha:SCRIM_ALPHA, onComplete:scrimShowComplete});
		}
		
		private function scrimShowComplete():void {
			trace("scrim show complete");
			
			//now reveal the dashboard
			fadeInDashboard();
		}
		
		private function hideScrim():void {
			TweenMax.to(scrim, .2, {autoAlpha:0, onComplete:zoomOutOfLocation});
		}
		
		/************************************************/
	}
}