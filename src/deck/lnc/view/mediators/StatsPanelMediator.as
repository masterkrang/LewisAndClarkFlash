package deck.lnc.view.mediators
{
	import deck.lnc.view.ui.stats.StatsPanel;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class StatsPanelMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "StatsPanelMediator";
		
		public function StatsPanelMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.DATA_READY
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case ApplicationFacade.DATA_READY:
					stats.dataProvider = note.getBody() as MapVO;
					break;
				default:
					break;
			}
		}
		
		public function get stats():StatsPanel {
			return viewComponent as StatsPanel;
		}
	}
}