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
	import flash.display.Stage;
	
	
	public class Farm extends Sprite
	{
		private var bgLoader:Loader;
		var controller:Controller;
		private var notLoadedCount:int = 0;
		private var windowWidth:int;
		private var windowHeight:int;
		private var backgroundWidth:int;
		private var backgroundHeight:int;
		
		private var toolbar:Toolbar;
		private var field:Sprite;
		
		public var currentState:String;
		
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
			bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			controller = new Controller(this);
			
			field = new Sprite();
			field.y = Constants.TOOLBAR_HEIGHT;
			this.addChild(field);
			
			field.addChild(bgLoader);
			bgLoader.load(new URLRequest("http://localhost:3000/images/BG.jpg"));
			
			toolbar = new Toolbar();
			this.addChild(toolbar);
			
			currentState = Constants.MOVE_STATE;
		}
		
		private function onLoadComplete(e:Event):void {
			windowWidth = (this.parent.parent as Stage).stageWidth;
			windowHeight = (this.parent.parent as Stage).stageHeight;
			backgroundWidth = bgLoader.width;
			backgroundHeight = bgLoader.height;
			
			field.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			field.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			field.addEventListener(MouseEvent.MOUSE_OUT, stopDragging);
		}
		
		private function startDragging(evt:MouseEvent):void
		{
			if (currentState == Constants.MOVE_STATE)
			{
				field.startDrag();
				field.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		function stopDragging(evt:MouseEvent):void
		{
			if (currentState == Constants.MOVE_STATE)
			{
				field.stopDrag();
				field.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		function onMove(evt:MouseEvent):void
		{
			if (field.x > 0)
				field.x = 0;
			else if (field.x < (windowWidth - backgroundWidth))
				field.x = windowWidth - backgroundWidth;
			if (field.y > Constants.TOOLBAR_HEIGHT)
				field.y = Constants.TOOLBAR_HEIGHT;
			else if (field.y < (windowHeight - backgroundHeight))
				field.y = windowHeight - backgroundHeight;
		}
		
		function onImageLoad(event:Event):void
		{
			notLoadedCount--;
			if (notLoadedCount == 0)
				drawVegetables();
		}
		
		private function loadImages():void
		{
			var growthStage:int;
			for each (var vegetable in controller.vegetables)
			{
				growthStage = vegetable.growthStage - 1;

				if (images[vegetable.type][growthStage].image == null)
				{
					var tempLoader:Loader = new Loader();
					tempLoader.load(new URLRequest(images[vegetable.type][growthStage].path));
					notLoadedCount++;
					tempLoader.contentLoaderInfo.addEventListener(Event.INIT, onImageLoad);
					images[vegetable.type][growthStage].image = tempLoader;
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
			var growthStage:int;
			for each (var vegetable in controller.vegetables)
			{
				growthStage = vegetable.growthStage - 1;

				if (vegetable.numChildren == 0)
				{
					vegetable.x = controller.FIELD_X0_PX + (vegetable.column + vegetable.row) * 55;
					field.addChild(vegetable);
				}
				else
				{
					var child:Bitmap = (vegetable as Vegetable).getChildAt(0) as Bitmap;
					(vegetable as Vegetable).removeChild(child);
					child = null;
				}
				vegetable.y = controller.FIELD_Y0_PX + (vegetable.column - 
							  vegetable.row) * 28 - images[vegetable.type][growthStage].y0;
				vegetable.addChild(new Bitmap(Bitmap((images[vegetable.type][growthStage].image as Loader).content).bitmapData.clone()));
				
				vegetable.addEventListener(MouseEvent.CLICK, vegetableClick);
			}
		}
		
		function vegetableClick(event:MouseEvent):void
		{
			if (currentState == Constants.HARVEST_STATE)
				controller.deleteVegetable(event.target as Vegetable);
		}
		
		function removeFromField(vegetable:Vegetable):void
		{
			vegetable.removeEventListener(MouseEvent.CLICK, vegetableClick);
			field.removeChild(vegetable);
		}
	}
}