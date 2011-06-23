package deck.lnc.controller
{
	import deck.lnc.ApplicationFacade;
	import deck.lnc.model.DataProxy;
	import deck.lnc.model.TwitterProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Kurt Braget joehaircut@gmail.com
	 */
	
	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void {
			//facade.registerProxy( new ScheduleProxy() );
			//facade.registerProxy( new SQLServiceProxy() );
			
			//general data for application (xml, sql, etc)
			facade.registerProxy( new DataProxy() );
			
			facade.registerProxy( new TwitterProxy() );
		}	
	}
}