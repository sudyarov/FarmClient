package views
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import models.Vegetable;	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Farm extends Sprite
	{
		private var bgLoader:Loader;
		var controller:Controller;
		//public var windowWidth:int;
		//public var windowHeight:int;
		private var backgroundWidth:int;
		private var backgroundHeight:int;
		
		private var toolbar:Toolbar;
		private var field:Sprite;
		private var grid:Grid;
		
		public var currentState:String;
		public var selectedVegType:String;
		
		private var messageWindow:MessageWindow;

		public var images:Object = {
			potato: [{y0: 26},	{y0: 26}, {y0: 42}, {y0: 45}, {y0: 50}], 
			clover: [{y0: 72},	{y0: 28}, {y0: 32}, {y0: 42}, {y0: 44}],
			sunflower: [{y0: 27}, {y0: 44}, {y0: 59}, {y0: 83}, {y0: 100}]
		};

		public function Farm()
		{
			field = new Sprite();
			field.y = Constants.TOOLBAR_HEIGHT;
			this.addChild(field);
			
			messageWindow = MessageWindow.getInstance();
			this.addChild(messageWindow);
			
			controller = new Controller(this);
			
			bgLoader = new Loader();
			bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			bgLoader.load(new URLRequest(Constants.SERVER_URL + Constants.FIELD_BACKGROUND_URL));
		}
		
		private function onLoadComplete(e:Event):void {
			backgroundWidth = bgLoader.width;
			backgroundHeight = bgLoader.height;
			
			field.addChild(bgLoader);
			
			field.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			field.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			field.addEventListener(MouseEvent.MOUSE_OUT, stopDragging);
			
			toolbar = new Toolbar();
			this.addChild(toolbar);
			
			grid = new Grid();
			field.addChild(grid);
			field.addEventListener(MouseEvent.CLICK, fieldClick);
			
			currentState = Constants.MOVE_STATE;
		}
		
		private function fieldClick(event:MouseEvent):void
		{
			if (this.currentState == Constants.ADD_STATE)
			{
				if (!(event.target is Vegetable))
				{
					var point:Point = grid.getCell(event.localX, event.localY);
					if (point != null)
					{
						// point.x - column
						// point.y - row
						controller.addVegetable(this.selectedVegType, point.y, point.x);
					}
					else
					{
						messageWindow.show(Constants.OUTSIDE_FIELD, Constants.MW_BOTTOM_LEFT, true);
					}
				}
				else
				{
					messageWindow.show(Constants.VEGETABLE_ALREADY_EXISTS, Constants.MW_BOTTOM_LEFT, true);
				}
			}
		}
		
		private function startDragging(evt:MouseEvent):void
		{
			if (currentState == Constants.MOVE_STATE)
			{
				field.startDrag();
				field.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		private function stopDragging(evt:MouseEvent):void
		{
			if (currentState == Constants.MOVE_STATE)
			{
				field.stopDrag();
				field.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		private function onMove(evt:MouseEvent):void
		{
			if (field.x > 0)
				field.x = 0;
			else if (field.x < (stage.stageWidth - backgroundWidth))
				field.x = stage.stageWidth - backgroundWidth;
			if (field.y > Constants.TOOLBAR_HEIGHT)
				field.y = Constants.TOOLBAR_HEIGHT;
			else if (field.y < (stage.stageHeight - backgroundHeight))
				field.y = stage.stageHeight - backgroundHeight;
		}

		private function loadImages():int
		{
			var growthStage:int;
			var result:int = 0;
			var notLoadedImages:Array = new Array();
			
			for each (var vegetable in controller.vegetables)
			{
				growthStage = vegetable.growthStage - 1;

				if (images[vegetable.type][growthStage].image == null)
				{
					notLoadedImages.push({vtype: vegetable.type, growthStage: vegetable.growthStage});
					result++;
				}
			}
			
			if (result != 0)
				controller.getImages(notLoadedImages);
			
			return result;
		}
		
		public function draw():void
		{
			if (loadImages() == 0)
				drawVegetables();
		}
		
		public function drawVegetables():void
		{
			var growthStage:int;
			var point:Point;
			
			for each (var vegetable in controller.vegetables)
			{
				growthStage = vegetable.growthStage - 1;

				point = grid.getCoords(vegetable.row, vegetable.column);

				if (vegetable.numChildren == 0)
				{
					vegetable.x = point.x + Constants.VEGETABLE_X_OFFSET;
					field.addChild(vegetable);
					vegetable.addEventListener(MouseEvent.CLICK, vegetableClick);
				}
				else
				{
					var child:Bitmap = (vegetable as Vegetable).getChildAt(0) as Bitmap;
					(vegetable as Vegetable).removeChild(child);
					child = null;
				}
				vegetable.y = point.y - images[vegetable.type][growthStage].y0;
				vegetable.addChild(new Bitmap((images[vegetable.type][growthStage].image as BitmapData).clone()));
			}
		}
		
		private function vegetableClick(event:MouseEvent):void
		{
			if (currentState == Constants.HARVEST_STATE)
				if ((event.target as Vegetable).growthStage < Constants.HARVEST_STAGE)
					messageWindow.show(Constants.NOT_GROWN, Constants.MW_BOTTOM_LEFT, true);
				else
					controller.deleteVegetable(event.target as Vegetable);
		}
		
		public function removeFromField(vegetable:Vegetable):void
		{
			vegetable.removeEventListener(MouseEvent.CLICK, vegetableClick);
			field.removeChild(vegetable);
		}
	}
}