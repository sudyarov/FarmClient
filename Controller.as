package
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import models.Vegetable;
	import flash.net.URLRequestMethod;
	import flash.events.MouseEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;

	public class Controller
	{
		private var loader:URLLoader;
		private var request:URLRequest;
		private var farm:Farm;
		private var id:int;
		private var notLoadedImages:Array;
		
		public const FIELD_X0_PX:int = 120;
		public const FIELD_Y0_PX:int = 430;
		
		public var vegetables:Array;
		
		//private var imageLoader:URLLoader;
		private var imageLoader:Loader;
		
		public function Controller(obj:Object)
		{
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaderCompleteHandler);
			
			farm = obj as Farm;
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			request = new URLRequest(Constants.SERVER_URL + Constants.MAIN_CONTROLLER_URL);
			request.method = URLRequestMethod.POST;
			vegetables = new Array();
			getField();
		}
		
		public function getImages(notLoadedImages:Array):void
		{
			this.notLoadedImages = notLoadedImages;
			
			var xmlRequest:XML = new XML("<command name=\"getImage\" type=\"\" stage=\"\" />");
			xmlRequest.@type = notLoadedImages[0].vtype;
			xmlRequest.@stage = notLoadedImages[0].growthStage;
			request.data = "command=" + xmlRequest.toXMLString();
			imageLoader.load(request);
		}
		
		public function imageLoaderCompleteHandler(event:Event):void
		{
			var veg:Object = this.notLoadedImages[0];
			farm.images[veg.vtype][veg.growthStage - 1].image = Bitmap(imageLoader.content).bitmapData.clone();

			this.notLoadedImages.shift();
			if (this.notLoadedImages.length != 0)
				getImages(notLoadedImages);
			else
				farm.drawVegetables();
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
				else if (command == "nextStep")
					nextStepHandler();
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
			for each (var vegetableXML:XML in xml.children())
			{
				vegetables.push(new Vegetable(vegetableXML));
			}
			farm.draw();
		}
		
		public function nextStep():void
		{
			var xmlRequest:XML = new XML("<command name=\"nextStep\" />");
			request.data = "command=" + xmlRequest.toXMLString();
			loader.load(request);
		}
		
		public function nextStepHandler():void
		{
			for each (var vegetable:Vegetable in vegetables)
			{
				if (vegetable.growthStage < 5)
					vegetable.growthStage++;
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
