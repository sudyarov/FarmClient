package
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import models.Vegetable;
	//import views.Farm;
	import views.MessageWindow;
	import flash.net.URLRequestMethod;

	public class Controller
	{
		private var loader:URLLoader;
		private var request:URLRequest;
		private var farm:Farm;
		private var id:int;
		private var messageWindow:MessageWindow;
        private var isNew:Boolean;
		
		public var vegetables:Array;

		public function Controller(farm:Farm)
		{
			this.farm = farm;
			messageWindow = MessageWindow.getInstance();
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			request = new URLRequest(Constants.SERVER_URL + Constants.MAIN_CONTROLLER_URL);
			request.method = URLRequestMethod.POST;
			vegetables = new Array();
			getField();
		}
		
		private function getIndexByVegetableId(id:int):int
		{
			var length:int = vegetables.length;
			for (var i:int = 0; i < length; i++)
				if (vegetables[i].id == id)
					return i;
			return -1;
		}
		
		private function loaderErrorHandler(event:IOErrorEvent):void
		{
			messageWindow.show(Constants.CONNECTION_LOST_MESSAGE, Constants.MW_CENTER, false);
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			/* check responce for errors*/
			var xml:XML = new XML(loader.data);
			if (xml.name() == Constants.ERROR_RESPONCE)
			{
				messageWindow.show(Constants.ERROR_MESSAGE, Constants.MW_CENTER, false);
			}
			else
			{
				/* launch handler if there are no errors */
				var command:String = xml.@name;
				if (command == Constants.FIELD_RESPONCE)
					getFieldHandler(xml);
				else if (command == Constants.VEGETABLE_ADDED_RESPONCE)
					addVegetableHandler(xml);
				else if (command == Constants.VEGETABLE_DELETED_RESPONCE)
					deleteVegetableHandler();
				else if (command == Constants.NEXT_STEP_RESPONCE)
					nextStepHandler();
			}
		}
		
		/* get field request */
		public function getField():void
		{
			var xmlRequest:XML = Constants.GET_FIELD_REQUEST;
			request.data = Constants.COMMAND_PARAMETER + xmlRequest.toXMLString();
			loader.load(request);
		}
		
		/* fills collection of vegetables */
		private function getFieldHandler(xml:XML):void
		{
			farm.setRowCount(xml.@rows);
			farm.setColCount(xml.@columns);

			for each (var vegetableXML:XML in xml.children())
			{
				vegetables.push(new Vegetable(vegetableXML));
			}
			farm.initComponents();
			farm.draw(false);
		}
		
		public function nextStep():void
		{
			var xmlRequest:XML = Constants.NEXT_STEP_REQUEST;
			request.data = Constants.COMMAND_PARAMETER + xmlRequest.toXMLString();
			loader.load(request);
		}
		
		private function nextStepHandler():void
		{
			for each (var vegetable:Vegetable in vegetables)
			{
				if (vegetable.growthStage < 5)
					vegetable.growthStage++;
			}
			farm.draw(false);
		}
		
		public function deleteVegetable(vegetable:Vegetable):void
		{
			this.id = vegetable.id;

			var xmlRequest:XML = Constants.DELETE_VEGETABLE_REQUEST;
			xmlRequest.vegetable.@id = this.id;
			request.data = Constants.COMMAND_PARAMETER + xmlRequest.toXMLString();
			
			loader.load(request);
		}
		
		private function deleteVegetableHandler():void
		{
			var index:int = getIndexByVegetableId(this.id);
			farm.removeFromField(vegetables[index]);
			vegetables.splice(index, 1);
		}
		
		public function addVegetable(type:String, row:int, column:int):void
		{
			var xmlRequest:XML = Constants.ADD_VEGETABLE_REQUEST;
			xmlRequest.vegetable.@type = type;
			xmlRequest.vegetable.@row = row;
			xmlRequest.vegetable.@column = column;
			request.data = Constants.COMMAND_PARAMETER + xmlRequest.toXMLString();
			
			loader.load(request);
		}
		
		private function addVegetableHandler(xml:XML):void
		{
			vegetables.push(new Vegetable(XML(xml.vegetable)));
			farm.draw(true);
		}
	}
}
