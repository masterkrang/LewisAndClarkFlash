package deck.lnc.controller 
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import deck.lnc.view.mediators.ApplicationMediator
	
	import deck.lnc.ApplicationFacade;
	
	/**
	 * ...
	 * @author Kurt Braget joehaircut@gmail.com
	 */
	
	public class ViewPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
		{
			// Register the ApplicationMediator
			facade.registerMediator( new ApplicationMediator( note.getBody() ) );            
			
			// Get the Proxy
			//facade.retrieveProxy( EmployeeProxy.NAME ) as EmployeeProxy;
			//proxy.loadSomething();
			
			//sendNotification( ApplicationFacade.VIEW_EMPLOYEE_LOGIN );
			
		}
	}

}