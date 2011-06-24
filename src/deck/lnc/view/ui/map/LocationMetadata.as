package deck.lnc.view.ui.map
{
	import com.greensock.TweenMax;
	import com.kurt.util.TextFormatFactory;
	
	import deck.lnc.model.vo.map.LocationVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LocationMetadata extends Sprite
	{
		private var bg:LocationMetadataBG;
		private var cloudTail:CloudTail; // bottom part of the cloud
		private var locationName:TextField;
		private var description:TextField;
		private var dashboardLink:TextField;
		
		private var closeButton:LocationMetadataCloseButton;
		
		private var data:LocationVO;
		
		public static const DASHBOARD_LINK_CLICK:String = "dashboardLinkClick";
		public static const METADATA_CLOSE:String = "metadataClose";
		public static const HIDE_COMPLETE:String = "metadataHideComplete";
		public static const ALPHA:Number = .85;
		
		public static const WIDTH:Number = 325;
		public static const HEIGHT:Number = 220;
		
		public static const PADDING:Number = 15;
		
		public var closeButtonClicked:Boolean = false;
		
		public var showing:Boolean = false
			
		public var _hasBeenInited:Boolean = false; //whether this panel has been shown or not
		
		public function LocationMetadata()
		{
			super();
			init();
		}
		
		private function init():void {
			
			//alpha = 0;
			
			bg = new LocationMetadataBG(); //getBackground();
			bg.scaleX = bg.scaleY = 0;
			
			
			cloudTail = new CloudTail();
			cloudTail.x = -85;
			cloudTail.y = 0;
			
			bg.alpha = cloudTail.alpha = ALPHA; //should be the same
			//works
			//setColor(bg, 0xFFFFFF);
			
			closeButton = new LocationMetadataCloseButton();
			closeButton.alpha = 0;
			//trace("closebutton x " + (closeButton.width + 5));
			closeButton.x = -30; //-(closeButton.width + 5);
			closeButton.y = -210;	
			closeButton.addEventListener(MouseEvent.CLICK, closeClick);
			
			locationName = new TextField();
			locationName.defaultTextFormat = TextFormatFactory.getLocationMetadataTitleFormat();
			TextFormatFactory.setTextParams(locationName);
			locationName.width = WIDTH - (PADDING * 2);
			
			description = new TextField();
			description.defaultTextFormat = TextFormatFactory.getLocationMetadataDescriptionFormat();
			TextFormatFactory.setTextParams(description);
			description.width = WIDTH - (PADDING * 2);
			
			dashboardLink = new TextField();
			dashboardLink.defaultTextFormat = TextFormatFactory.getLocationMetadataDashboardLinkFormat();
			TextFormatFactory.setTextParams(dashboardLink);
			dashboardLink.width = WIDTH - (PADDING * 2);
			
			
			draw();
		}
		
		private function closeClick(me:MouseEvent):void {
			closeButtonClicked = true;
			hide();
			
			//dispatchEvent(new Event(METADATA_CLOSE));
		}
		
		private function getBackground():MovieClip {
			
			return new LocationMetadataBG();
		}
		
		public function set dataProvider(_data:LocationVO):void {
			data = _data;
			trace("LocationMetadata::dataProvider");
			
			setContents();
			
		}
		
		private function draw():void {
			
			addChild(bg);
			
			addChild(cloudTail);
			
			addChild(locationName);
			
			addChild(description);
			
			addChild(dashboardLink);
			
			addChild(closeButton);
		}
		
		public function setContents():void {
			locationName.text = data.title;
			locationName.x = -(WIDTH - PADDING);
			locationName.y = -(HEIGHT - PADDING);
			
			//should probably be in a scrollpane
			description.text = data.description;
			description.x = -(WIDTH - PADDING);
			description.y = -(HEIGHT - (PADDING + locationName.height + PADDING));
			
			dashboardLink.text = "View Dashboard"; //data.dashboardPath;
			dashboardLink.x = -(WIDTH - PADDING);
			dashboardLink.y = -(cloudTail.height);
			dashboardLink.textColor = 0x000000;
		}
		
		private function showContents():void {
			TweenMax.to(closeButton, .2, {alpha:1});
			TweenMax.to(locationName, .2, {alpha:1});
			TweenMax.to(description, .2, {alpha:1});
			TweenMax.to(locationName, .2, {alpha:1});
		}
		
		private function hideContents():void {
			TweenMax.to(closeButton, .2, {alpha:0});
			TweenMax.to(locationName, .2, {alpha:0});
			TweenMax.to(description, .2, {alpha:0});
			//add callback
			TweenMax.to(locationName, .05, {alpha:0, onComplete:hideContentsComplete});
		}
		
		private function hideContentsComplete():void {
			hideBG();
		}
		
		private function hideBG():void {
			var hideTime:Number = .1;
			TweenMax.to(this, hideTime, {alpha:0});
			TweenMax.to(bg, hideTime, {scaleX:0, scaleY:0, onComplete:hideBGComplete});
		}
		
		public function setColor(mc:MovieClip, _color:int):void {
			var newColorTransform:ColorTransform = mc.transform.colorTransform;// mc.transform.colorTransform;
			newColorTransform.color = 0xFF0000;//FF0000;
			mc.transform.colorTransform = newColorTransform;
		}
		
		public function hasBeenInited():Boolean {
			return _hasBeenInited;
		}
		
		public function show():void {
			_hasBeenInited = true;
			showBG();
			setShowing(true);
		}
		
		public function setShowing(_showing:Boolean):void {
			showing = _showing;
		}
		
		public function isShowing():Boolean {
			return showing;
		}
		
		private function showBG():void {
			var showTime:Number = .15;
			TweenMax.to(this, showTime, {alpha:1});
			TweenMax.to(bg, showTime, {scaleX:1, scaleY:1, onComplete:showBGComplete});
		}
		
		public function hide():void {
			//first hide contents, then bg
			hideContents();
			setShowing(false);
		}
		
		private function showBGComplete():void {
			//show the rest of the data
			trace("showBGComplete");
			showContents();
		}
		
		private function hideBGComplete():void {
			//TweenMax.to(closeButton, .2, {autoAlpha:0});
			//dispatchEvent(new Event(HIDE_COMPLETE));
			
			//differentiated between a close 'x" click and simply clicking on another location
			//if the 'x' is clicked then we need to tell the framework to zoom out
			if(closeButtonClicked) {
				trace("dispatching metadata_closed");
				dispatchEvent(new Event(METADATA_CLOSE));
				closeButtonClicked = true;
			}
			
		}
	}
}