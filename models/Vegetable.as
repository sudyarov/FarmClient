package  models
{
	public class Vegetable
	{
		private var id:int;
		private var type:int;
		private var x:int;
		private var y:int;
		private var stage:int;

		public function Vegetable(xml:XML)
		{
			id = xml.@id;
			type = xml.@type;
			x = xml.@x;
			y = xml.@y;
			stage = xml.@stage;
		}
	}
}
