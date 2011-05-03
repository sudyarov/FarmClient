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
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Point;
	
	
	public class Farm extends Sprite
	{
		private var bgLoader:Loader;
		var controller:Controller;
		public var windowWidth:int;
		public var windowHeight:int;
		private var backgroundWidth:int;
		private var backgroundHeight:int;
		
		private var toolbar:Toolbar;
		private var field:Sprite;
		private var grid:Sprite;
		
		public var currentState:String;
		public var selectedVegType:String;
		
		public var images:Object = {
			potato: [{image: null, y0: 26},	{image: null, y0: 26}, {image: null, y0: 42},
					 {image: null, y0: 45},	{image: null, y0: 50}
				    ], 
			clover: [{image: null, y0: 72},	{image: null, y0: 28}, {image: null, y0: 32},
					 {image: null, y0: 42},	{image: null, y0: 44}
				    ],
			sunflower: [{image: null, y0: 27}, {image: null, y0: 44}, {image: null, y0: 59},
					    {image: null, y0: 83}, {image: null, y0: 100}
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
			bgLoader.load(new URLRequest(Constants.SERVER_URL + Constants.FIELD_BACKGROUND_URL));
			
			toolbar = new Toolbar();
			this.addChild(toolbar);
			
			currentState = Constants.MOVE_STATE;
			
			grid = new Sprite();
			field.addChild(grid);
			field.addEventListener(MouseEvent.CLICK, gridClick);
			drawGrid();
		}
		
		private function gridClick(event:MouseEvent):void
		{
			if (this.currentState == Constants.ADD_STATE)
			{
				if (!(event.target is Vegetable))
				{
					var point:Point = getCell(event.localX, event.localY);
					if (point != null)
					{
						// point.x - column
						// point.y - row
						controller.addVegetable(this.selectedVegType, point.y, point.x);
					}
				}
			}
		}
		
		private function getCoords(row:int, column:int):Point
		{
			var result:Point = new Point();
			
			// rotate
			// x' = x*cos(a) - y*sin(a)
			// y' = x*sin(a) + y*cos(a)
			result.x = (column * Constants.COL_WIDTH) * Math.cos(Constants.ROTATE_ANGLE) + 
				       (row * Constants.ROW_HEIGHT) * Math.sin(Constants.ROTATE_ANGLE);
			result.y = (column * Constants.COL_WIDTH) * Math.sin(Constants.ROTATE_ANGLE) - 
				       (row * Constants.ROW_HEIGHT) * Math.cos(Constants.ROTATE_ANGLE);
			
			// compression
			result.y *= Constants.COMPRESSION;
			
			// shift
			result.x += Constants.FIELD_X0_PX;
			result.y += Constants.FIELD_Y0_PX;
			
			return result;
		}
		
		private function getCell(x:Number, y:Number):Point
		{
			var result:Point = new Point();
			
			x -= Constants.FIELD_X0_PX;
			y -= Constants.FIELD_Y0_PX;
			
			// uncompress
			y /= Constants.COMPRESSION;
			
			// rotate
			result.x = x * Math.cos(Constants.ROTATE_ANGLE) + 
				       y * Math.sin(Constants.ROTATE_ANGLE);
			result.y = x * Math.sin(Constants.ROTATE_ANGLE) - 
				       y * Math.cos(Constants.ROTATE_ANGLE);
			
			// outside field
			if ((result.x < 0) || (result.y < 0))
				return null;
			else if ((result.x > (Constants.COL_COUNT * Constants.COL_WIDTH)) || 
					 (result.y > (Constants.ROW_COUNT * Constants.ROW_HEIGHT)))
				return null;
			
			// get row and column indexes
			result.x = (int)(result.x / Constants.COL_WIDTH);
			result.y = (int)(result.y / Constants.ROW_HEIGHT);
			
			return result;
		}
		
		private function drawGrid():void
		{
			var point:Point;
			var i:int;

			grid.graphics.lineStyle(1, 0xCCCCCC);
			for (i = 0; i <= Constants.ROW_COUNT; i++)
			{
				point = getCoords(i, 0);
				grid.graphics.moveTo(point.x, point.y);
				
				point = getCoords(i, Constants.COL_COUNT);
				grid.graphics.lineTo(point.x, point.y);
			}
			
			for (i = 0; i <= Constants.COL_COUNT; i++)
			{
				point = getCoords(0, i);
				grid.graphics.moveTo(point.x, point.y);
				
				point = getCoords(Constants.COL_COUNT, i);
				grid.graphics.lineTo(point.x, point.y);
			}
		}
		
		private function onLoadComplete(e:Event):void {
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
			else if (field.x < (windowWidth - backgroundWidth))
				field.x = windowWidth - backgroundWidth;
			if (field.y > Constants.TOOLBAR_HEIGHT)
				field.y = Constants.TOOLBAR_HEIGHT;
			else if (field.y < (windowHeight - backgroundHeight))
				field.y = windowHeight - backgroundHeight;
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

				point = getCoords(vegetable.row, vegetable.column);

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
				controller.deleteVegetable(event.target as Vegetable);
		}
		
		public function removeFromField(vegetable:Vegetable):void
		{
			vegetable.removeEventListener(MouseEvent.CLICK, vegetableClick);
			field.removeChild(vegetable);
		}
	}
}