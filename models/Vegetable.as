package  models
{
	public class Vegetable
	{
		private var id:int;
		public var type:int;
		public var column:int;
		public var row:int;
		public var stage:int;

		public function Vegetable(xml:XML)
		{
			id = xml.@id;
			type = xml.@type;
			column = xml.@x;
			row = xml.@y;
			stage = xml.@stage;
		}
		/*
		public function toString():String
		{
			return "id=" + id + "|type=" + type + "|x=" + x + "|y=" + y + "|stage=" + stage;
		}
		*/
	}
}
