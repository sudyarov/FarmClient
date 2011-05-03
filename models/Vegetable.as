package  models
{
	import flash.display.Sprite;

	public class Vegetable extends Sprite
	{
		public var id:int;
		public var type:String;
		public var row:int;
		public var column:int;
		public var growthStage:int;

		public function Vegetable(xml:XML)
		{
			id = xml.@id;
			type = xml.@type;
			row = xml.@row;
			column = xml.@column;
			growthStage = xml.@stage;
		}
	}
}
