package
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import models.Vegetable;
	import flash.net.URLRequestMethod;
	import flash.events.MouseEvent;

	public class Controller
	{
		private static const URL:String = "http://localhost:3000/request/main";
		
		private var loader:URLLoader;
		private var request:URLRequest;
		private var farm:Farm;
		private var id:int;
		
		public const FIELD_X0_PX:int = 120;
		public const FIELD_Y0_PX:int = 430;
		
		public var vegetables:Array;
		
		public function Controller(obj:Object)
		{
			farm = obj as Farm;
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			request = new URLRequest(URL);
			request.method = URLRequestMethod.POST;
			vegetables = new Array();
			getField();
		}
		
		public function getIndexByVegetableId(id:int):int
		{
			var length:int = vegetables.length;
			for (var i:int = 0; i < length; i++)
				if (vegetables[i].id == id)
					return i;
			return -1;
		}
		
		public function loaderErrorHandler(event:IOErrorEvent):void
		{
			// обработать ошибку (как то отобразить)
		}
		
		public function loaderCompleteHandler(event:Event):void
		{
			/* check responce for errors*/
			var xml:XML = new XML(loader.data);
			if (xml.name() == "error")
			{
				trace("error");
			}
			else
			{
				/* launch handler if there are no errors */
				var command:String = xml.@name;
				if (command == "field")
					getFieldHandler(xml);
					/*
				else if (command == "vegetableAdded")
					addVegetableHandler(xml);
					*/
				else if (command == "vegetableDeleted")
					deleteVegetableHandler();
			}
		}
		
		public function getField():void
		{
			var xmlRequest:XML = new XML("<command name=\"getField\" />");
			request.data = "command=" + xmlRequest.toXMLString();
			loader.load(request);
		}
		
		/* fills collection of vegetables */
		public function getFieldHandler(xml:XML):void
		{
			vegetables.length = 0;
			
			for each (var vegetableXML:XML in xml.children())
			{
				vegetables.push(new Vegetable(vegetableXML));
			}
			farm.draw();
		}
		
		public function deleteVegetable(vegetable:Vegetable):void
		{
			this.id = vegetable.id;
			var xmlRequest:XML = new XML("<command name=\"delVegetable\"><vegetable id=\"\" /></command>");
			xmlRequest.vegetable.@id = this.id;
			request.data = "command=" + xmlRequest.toXMLString();
			
			loader.load(request);
		}
		
		public function deleteVegetableHandler():void
		{
			var index:int = getIndexByVegetableId(this.id);
			farm.removeFromField(vegetables[index]);
			vegetables.splice(index, 1);
		}
	}
}
