package deck.lnc
{
	import deck.lnc.controller.ApplicationStartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.observer.Notification;
	import org.puremvc.as3.patterns.proxy.*;

	public class ApplicationFacade extends Facade implements IFacade
	{
		/* event constants */
		public static const STARTUP:String 					= "startup";
		
		//data ready
		public static const DATA_READY:String				= "dataReady";
		
		//twitter data
		public static const TWITTER_DATA_READY:String 		= "twitterDataReady";
		
		//list panel events
		public static const LIST_PANEL_CLICK:String 		= "listPanelClick";
		public static const LIST_PANEL_MOUSE_OVER:String 	= "listPanelMouseOver";
		public static const LIST_PANEL_MOUSE_OUT:String 	= "listPanelMouseOut";
		
		//map events
		public static const MAP_LOCATION_CLICK:String 	= "mapLocationClick";
		
		//dashboard
		public static const OPEN_DASHBOARD:String 			= "openDashboard";
		
		
		public static function getInstance():ApplicationFacade {
			if (instance == null) {
				new ApplicationFacade();
			}
			
			return instance as ApplicationFacade;
		}
		
		public function startup(app:LewisAndClarkFlash):void {
			trace("ApplicationFacade::startup()");
			
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void {
			super.initializeController();
			
			registerCommand(STARTUP, ApplicationStartupCommand);
		}
		
	}
}