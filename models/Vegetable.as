package  models
{
	import flash.display.Sprite;

	public class Vegetable
	{
		private var id:int;
		public var type:String;
		public var row:int;
		public var column:int;
		public var stage:int;
		public var sprite:Sprite;

		public function Vegetable(xml:XML)
		{
			id = xml.@id;
			type = xml.@type;
			row = xml.@row;
			column = xml.@column;
			stage = xml.@stage;
			sprite = new Sprite();
		}
		/*
		public function toString():String
		{
			return "id=" + id + "|type=" + type + "|x=" + x + "|y=" + y + "|stage=" + stage;
		}
		*/
	}
}
