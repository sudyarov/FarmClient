package
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import models.Vegetable;	
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
			//this.startDrag(false, new Rectangle(0, 0, 1565, 908));
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
			for each (var vegetable in controller.vegetables)
			{
				stage = vegetable.stage - 1;

				if (images[vegetable.type][stage].image == null)
				{
					var tempLoader:Loader = new Loader();
					tempLoader.load(new URLRequest(images[vegetable.type][stage].path));
					notLoadedCount++;
					tempLoader.contentLoaderInfo.addEventListener(Event.INIT, onImageLoad);
					images[vegetable.type][stage].image = tempLoader;
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
			for each (var vegetable in controller.vegetables)
			{
				stage = vegetable.stage - 1;

				//trace(vegetable);
				vegetable.sprite.x = controller.FIELD_X0_PX + (vegetable.column + vegetable.row) * 55;
				vegetable.sprite.y = controller.FIELD_Y0_PX + (vegetable.column - 
									 vegetable.row) * 28 - images[vegetable.type][stage].y0;
				this.addChild(vegetable.sprite);
				vegetable.sprite.addChild(new Bitmap(Bitmap((images[vegetable.type][stage].image as Loader).content).bitmapData.clone()));
				
				vegetable.sprite.addEventListener(MouseEvent.CLICK, vegetableClick);
			}
		}
		
		function vegetableClick(event:MouseEvent):void
		{
			trace(Vegetable(event.target).row);
		}
	}
}