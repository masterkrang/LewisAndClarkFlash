package deck.lnc.model.vo.map
{
	public class SectionVO
	{
		public var sectionName:String;
		public var locations:Vector.<LocationVO>;
		public function SectionVO()
		{
			locations = new Vector.<LocationVO>();
		}
	}
}