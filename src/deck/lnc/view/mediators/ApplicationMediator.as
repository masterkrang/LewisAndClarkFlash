package deck.lnc.view.mediators
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.model.vo.map.MapVO;
	import deck.lnc.model.vo.twitter.TwitterVO;
	import deck.lnc.view.ui.map.Location;
	
	import flash.events.DataEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
			
			//register view components
			facade.registerMediator( new TwitterWidgetMediator( app.twitterWidget ) );
			facade.registerMediator( new MapMediator( app.map ) );
			facade.registerMediator( new ListPanelMediator( app.list ) );
			facade.registerMediator( new DashboardMediator( app.dashboard ) );
			
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.DATA_READY,
				ApplicationFacade.LIST_PANEL_CLICK,
				ApplicationFacade.MAP_LOCATION_CLICK
			];
		}
		
		override public function handleNotification(note:INotification):void {
			//trace("AppMediator::handleNotification() " + note.getBody());
			switch (note.getName()) {
				case ApplicationFacade.DATA_READY:
					trace(NAME + "::" + ApplicationFacade.DATA_READY);
					//sendNotification(ApplicationFacade.DATA_READY, note.getBody() as MapVO);
					break;
				case ApplicationFacade.OPEN_DASHBOARD: 
					trace(NAME + "::" + ApplicationFacade.OPEN_DASHBOARD);
					//app.openDashboard(note.getBody() as LocationVO);
					break;
				case ApplicationFacade.LIST_PANEL_CLICK:
					trace(NAME + "::" + note.getName());
					app.onListPanelClicked(note.getBody() as LocationVO);
					break;
				case ApplicationFacade.MAP_LOCATION_CLICK:
					//trace(NAME + "::" + note.getName());
					app.mapLocationClick(note.getBody() as Location);
					break;
				
				//listen for external interface calls (javascript calls)
				//case ApplicationFacade.OPEN_DASHBOARD
				default:
					trace("ApplicationMediator notification not handled");
					break;
			}
		}
		
		protected function get app():LewisAndClarkFlash
		{
			return viewComponent as LewisAndClarkFlash;
		}
	}
}