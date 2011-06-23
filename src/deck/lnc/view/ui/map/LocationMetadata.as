package deck.lnc.view.ui.map
{
	import com.greensock.TweenMax;
	
	import deck.lnc.model.vo.map.LocationVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class LocationMetadata extends Sprite
	{
		private var bg:LocationMetadataBG;
		private var locationName:TextField;
		private var description:TextField;
		private var dashboardLink:TextField;
		
		private var closeButton:LocationMetadataCloseButton;
		
		private var data:LocationVO;
		
		public static const DASHBOARD_LINK_CLICK:String = "dashboardLinkClick";
		public static const METADATA_CLOSE:String = "metadataClose";
		public static const HIDE_COMPLETE:String = "metadataHideComplete";
		
		public function LocationMetadata()
		{
			super();
			init();
		}
		
		private function init():void {
			
			bg = new LocationMetadataBG(); //getBackground();
			bg.scaleX = bg.scaleY = 0;
			
			closeButton = new LocationMetadataCloseButton();
			closeButton.alpha = 0;
			closeButton.addEventListener(MouseEvent.CLICK, closeClick);
			
			locationName = new TextField();
			description = new TextField();
			dashboardLink = new TextField();
			
			draw();
		}
		
		private function closeClick(me:MouseEvent):void {
			hide();
			
			dispatchEvent(new Event(METADATA_CLOSE));
		}
		
		private function getBackground():MovieClip {
			
			return new LocationMetadataBG();
			
			/*
			var mc:MovieClip = new MovieClip();
			
			mc.graphics.beginFill(0x000000);
			mc.graphics.drawRect(0,0,400, 300);
			mc.graphics.endFill();
			
			return mc;
			*/
		}
		
		public function set dataProvider(_data:LocationVO):void {
			data = _data;
			
		}
		
		private function draw():void {
			
			addChild(bg);
			
			addChild(locationName);
			
			addChild(description);
			
			addChild(dashboardLink);
			
			addChild(closeButton);
		}
		
		public function show():void {
			TweenMax.to(bg, .15, {scaleX:1, scaleY:1, onComplete:showBGComplete});
		}
		
		public function hide():void {
			//first hide contents, then bg
			TweenMax.to(bg, .15, {scaleX:0, scaleY:0, onComplete:hideBGComplete});
		}
		
		private function showBGComplete():void {
			//show the rest of the data
			trace("showBGComplete");
			TweenMax.to(closeButton, .2, {autoAlpha:1});
		}
		
		private function hideBGComplete():void {
			TweenMax.to(closeButton, .2, {autoAlpha:0});
			dispatchEvent(new Event(HIDE_COMPLETE));
		}
	}
}