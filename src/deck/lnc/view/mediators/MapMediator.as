package deck.lnc.view.mediators
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.model.vo.map.MapVO;
	import deck.lnc.view.ui.map.Location;
	import deck.lnc.view.ui.map.Map;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MapMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MapMediator";
		
		public function MapMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			//add click to resize map or clicked item
			map.addEventListener(Map.LOCATION_CLICK, onLocationClick);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.DATA_READY,
				ApplicationFacade.LIST_PANEL_CLICK,
				ApplicationFacade.LIST_PANEL_MOUSE_OUT,
				ApplicationFacade.LIST_PANEL_MOUSE_OVER
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case ApplicationFacade.DATA_READY:
					map.dataProvider = note.getBody() as MapVO;
					break;
				case ApplicationFacade.LIST_PANEL_CLICK:
					//trace("MapMediator list panel click " + note.getBody());
					map.simulateLocationClick(note.getBody() as uint);
					break;
				case ApplicationFacade.LIST_PANEL_MOUSE_OUT:
					//trace("MapMediator list panel mouse out");
					map.simulateLocationOut(note.getBody() as uint);
					break;
				case ApplicationFacade.LIST_PANEL_MOUSE_OVER:
					//trace("MapMediator list panel mouse over");
					map.simulateLocationOver(note.getBody() as uint);
					break;
				default:
					break;
			}
		}
		
		public function onLocationClick(e:Event):void {
			
			trace("map.locations[map.getSelected()] " + map.locations[map.getSelected()]);
			var clickedLocation:Location = map.locations[map.getSelected()]; //Location(e.target).dataProvider;
			trace("MapMediator::onLocationClick " + clickedLocation);
			sendNotification(ApplicationFacade.MAP_LOCATION_CLICK, clickedLocation);
		}
		
		public function get map():Map {
			return viewComponent as Map;
		}
	}
}