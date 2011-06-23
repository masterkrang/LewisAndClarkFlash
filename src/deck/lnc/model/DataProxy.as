package deck.lnc.model
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.model.vo.map.MapVO;
	import deck.lnc.model.vo.map.SectionVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DataProxy extends Proxy implements IProxy
	{
		
		//xml
		private var xmlLoader:URLLoader;
		private var xmlPath:String = "assets/xml/map.xml";
		private var xml:XML;
		
		private var mapVO:MapVO;
		
		public static const NAME:String = "DataProxy";
		
		public function DataProxy(data:Object=null)
		{
			super(NAME, data);
			
			init();
		}
		
		private function init():void {
			
			//dataVO = new DataVO();
			
			mapVO = new MapVO();
			
			//load the data
			//load xml
			loadXML();
			
		}
		
		private function loadXML():void {
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlIOError);
			//xmlLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, xmlLoaded);
			//xmlLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, xmlIOError);
			xmlLoader.load(new URLRequest(xmlPath));
		}
		
		private function xmlIOError(ieo:IOErrorEvent):void {
			trace("xml cannot load " + ieo.toString());
		}
		
		private function xmlLoaded(e:Event):void {
			
			xml = XML(e.target.data);
			
			trace("xml loaded " + xml.mapurl);
			
			mapVO = getMapVO(xml);
			
			broadcastData();
		}
		
		private function getMapVO(xml:XML):MapVO {
			var mvo:MapVO = new MapVO();
			
			var sectionsLength:uint = xml.locations.section.length();
			//trace("sections length " + sectionsLength);
			for (var i:uint = 0; i < sectionsLength; i++) {
				mvo.sections.push(getSectionVO(xml.locations.section[i]));
			}
			return mvo;
		}
		
		private function getSectionVO(xml:XML):SectionVO {
			//trace("create section");
			var svo:SectionVO = new SectionVO();
			svo.sectionName = xml.@name;
			
			var locationsLength:Number = xml.location.length();
			for (var i:uint = 0; i < locationsLength; i++) {
				var locationVO:LocationVO = getLocationVO(xml.location[i]);
				//location.setIndex(i);
				svo.locations.push(locationVO);
			}
			
			return svo;
		}
		
		private function getLocationVO(xml:XML):LocationVO {
			var lvo:LocationVO = new LocationVO();
			
			lvo.xPosition = xml.xposition;
			lvo.yPosition = xml.yposition;
			lvo.title = xml.title;
			lvo.description = xml.description;
			lvo.buildingNumber = xml.buildingnumber;
			lvo.dashboardPath = xml.dashboardpath;
			
			return lvo;
		}
		
		private function broadcastData():void {
			//trace("broadcastdata sections length " + mapVO.sections.length); 
			sendNotification(ApplicationFacade.DATA_READY, mapVO);
		}
	}
}