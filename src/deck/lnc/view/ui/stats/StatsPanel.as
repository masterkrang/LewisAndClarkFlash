package deck.lnc.view.ui.stats
{
	import deck.lnc.model.vo.stats.StatsVO;
	
	import flash.display.Sprite;
	
	public class StatsPanel extends Sprite
	{
		private var statsVO:StatsVO;
		
		public function StatsPanel()
		{
			super();
		}
		
		public function set dataProvider(_statsVO:StatsVO):void {
				statsVO = _statsVO;
		}
	}
}