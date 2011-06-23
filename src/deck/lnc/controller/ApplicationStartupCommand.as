package deck.lnc.controller 
{
	import org.puremvc.as3.core.Controller;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.interfaces.*;

	/**
	 * ...
	 * @author Kurt Braget joehaircut@gmail.com
	 */
	public class ApplicationStartupCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void {
			addSubCommand(ViewPrepCommand);
			addSubCommand(ModelPrepCommand);
		}
	}
}