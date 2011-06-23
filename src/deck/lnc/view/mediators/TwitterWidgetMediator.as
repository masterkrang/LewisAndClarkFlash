package deck.lnc.view.mediators
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.vo.twitter.TwitterVO;
	import deck.lnc.view.ui.twitterwidget.TwitterWidget;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TwitterWidgetMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TwitterWidgetMediator";
		
		public function TwitterWidgetMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.TWITTER_DATA_READY
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case ApplicationFacade.TWITTER_DATA_READY:
					twitterWidget.dataProvider = note.getBody() as TwitterVO;
					break;
				default:
					break;
			}
		}
		
		public function get twitterWidget():TwitterWidget {
			return viewComponent as TwitterWidget;
		}
	}
}