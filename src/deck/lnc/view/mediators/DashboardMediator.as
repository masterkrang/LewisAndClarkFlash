package deck.lnc.view.mediators
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.view.ui.Dashboard;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class DashboardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DashboardMediator";
		public function DashboardMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.OPEN_DASHBOARD
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case ApplicationFacade.OPEN_DASHBOARD:
					dashboard.dataProvider = note.getBody() as LocationVO;
					break;
				default:
					break;
			}
		}
		
		public function get dashboard():Dashboard {
			return viewComponent as Dashboard;
		} 
	}
}