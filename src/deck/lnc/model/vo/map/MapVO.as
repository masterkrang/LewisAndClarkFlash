package deck.lnc.model.vo.map
{
	public class MapVO
	{
		
		public var sections:Vector.<SectionVO>;
		public function MapVO()
		{
			init();
		}
		
		private function init():void {
			sections = new Vector.<SectionVO>();
		}
	}
}