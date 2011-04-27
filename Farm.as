package
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import models.Vegetable;	
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Farm extends Sprite
	{
		private var bgLoader:Loader;
		var controller:Controller;
		private var notLoadedCount:int = 0;
		
		var images:Object = {potato: [
					{path: "http://localhost:3000/images/potato/Image 1.png", 
					 image: null, y0: 24},
					{path: "http://localhost:3000/images/potato/Image 3.png", 
					 image: null, y0: 24},
					{path: "http://localhost:3000/images/potato/Image 5.png", 
					 image: null, y0: 40},
					 {path: "http://localhost:3000/images/potato/Image 7.png", 
					 image: null, y0: 43},
					 {path: "http://localhost:3000/images/potato/Image 10.png", 
					 image: null, y0: 48}
				   ], 
				   clover: [
					{path: "http://localhost:3000/images/clover/Image 1.png", 
					 image: null, y0: 70},
					{path: "http://localhost:3000/images/clover/Image 3.png", 
					 image: null, y0: 26},
					{path: "http://localhost:3000/images/clover/Image 5.png", 
					 image: null, y0: 30},
					 {path: "http://localhost:3000/images/clover/Image 7.png", 
					 image: null, y0: 40},
					 {path: "http://localhost:3000/images/clover/Image 9.png", 
					 image: null, y0: 42}
				   ],
				   sunflower: [
					{path: "http://localhost:3000/images/sunflower/Image 1.png", 
					 image: null, y0: 25},
					{path: "http://localhost:3000/images/sunflower/Image 3.png", 
					 image: null, y0: 42},
					{path: "http://localhost:3000/images/sunflower/Image 5.png", 
					 image: null, y0: 57},
					 {path: "http://localhost:3000/images/sunflower/Image 7.png", 
					 image: null, y0: 81},
					 {path: "http://localhost:3000/images/sunflower/Image 9.png", 
					 image: null, y0: 98}
				   ]};
		
		private const CLOVER:int = 1;
		private const SUNFLOWER:int = 2;
		private const POTATO:int = 3;
		
		public function Farm()
		{
			bgLoader = new Loader();
			controller = new Controller(this);
			
			this.addChild(bgLoader);
			bgLoader.load(new URLRequest("http://localhost:3000/images/BG.jpg"));
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			this.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			this.addEventListener(MouseEvent.MOUSE_OUT, stopDragging);
		}
		
		function startDragging(evt:MouseEvent):void
		{
			this.startDrag();
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		function stopDragging(evt:MouseEvent):void
		{
			this.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		function onMove(evt:MouseEvent):void
		{
			//var width = mainSprite.width;
			
			if (this.x > 0)
				this.x = 0;
			if (this.y > 0)
				this.y = 0;
			
			// "отанавливать" drag справа
		}
		
		function onImageLoad(event:Event):void
		{
			notLoadedCount--;
			if (notLoadedCount == 0)
				drawVegetables();
		}
		
		private function loadImages():void
		{
			var stage:int;
			var vegType:String;
			for each (var vegetable in controller.vegetables)
			{
				stage = vegetable.stage - 1;
				if (vegetable.type == 1)
					vegType = "clover";
				else if (vegetable.type == 2)
					vegType = "sunflower";
				else if (vegetable.type == 3)
					vegType = "potato";
				if (images[vegType][stage].image == null)
				{
					var tempLoader:Loader = new Loader();
					tempLoader.load(new URLRequest(images[vegType][stage].path));
					notLoadedCount++;
					tempLoader.contentLoaderInfo.addEventListener(Event.INIT, onImageLoad);
					images[vegType][stage].image = tempLoader;
				}

			}
		}
		
		function draw():void
		{
			loadImages();
			if (notLoadedCount == 0)
				drawVegetables();
		}
		
		function drawVegetables():void
		{
			var stage:int;
			var vegType:String;
			for each (var vegetable in controller.vegetables)
			{
				stage = vegetable.stage - 1;
				if (vegetable.type == 1)
					vegType = "clover";
				else if (vegetable.type == 2)
					vegType = "sunflower";
				else if (vegetable.type == 3)
					vegType = "potato";
					
				trace(vegetable);
				var temp:Sprite = new Sprite();
				temp.x = controller.FIELD_X0_PX + (vegetable.column + vegetable.row) * 55;
				temp.y = controller.FIELD_Y0_PX + (vegetable.column - vegetable.row) * 28 - 
						 images[vegType][stage].y0;
				temp.scaleX = 1;
				temp.scaleY = 1;
				this.addChild(temp);
				temp.addChild(new Bitmap(Bitmap((images[vegType][stage].image as Loader).content).bitmapData.clone()));

			}
		}
	}
}