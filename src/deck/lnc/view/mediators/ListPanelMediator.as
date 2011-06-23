package deck.lnc.view.mediators
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.map.MapVO;
	import deck.lnc.view.ui.listpanel.ListPanel;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ListPanelMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ListMediator";
		
		public function ListPanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			
			//add listeners
			list.addEventListener(ListPanel.MOUSE_CLICK, listPanelClick);
			list.addEventListener(ListPanel.MOUSE_OUT, listPanelMouseOut);
			list.addEventListener(ListPanel.MOUSE_OVER, listPanelMouseOver);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.DATA_READY
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case ApplicationFacade.DATA_READY:
					list.dataProvider = note.getBody() as MapVO;
					break;
				default:
					break;
			}
		}
		
		public function get list():ListPanel {
			return viewComponent as ListPanel;
		} 
		
		//events
		private function listPanelMouseOut(e:Event):void {
			//trace("ListPanelMediator::listPanelMouseOut");
			sendNotification(ApplicationFacade.LIST_PANEL_MOUSE_OUT, list.getOutIndex());
		}
		
		private function listPanelMouseOver(e:Event):void {
			//trace("ListPanelMediator::listPanelMouseOver");
			sendNotification(ApplicationFacade.LIST_PANEL_MOUSE_OVER, list.getOverIndex());
		}
		
		private function listPanelClick(e:Event):void {
			sendNotification(ApplicationFacade.LIST_PANEL_CLICK, list.getSelectedIndex());
		}
	}
}