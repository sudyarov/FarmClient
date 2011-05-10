package views
{
    import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.filters.BitmapFilter;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.geom.Matrix;

	public class Toolbar extends Sprite
	{
		private var moveButton:Sprite;
		private var addButton:Sprite;
		private var removeButton:Sprite;
		private var harvestButton:Sprite;
		private var nextStepButton:Sprite;
		
		private var addPotatoButton:Sprite;
		private var addCloverButton:Sprite;
		private var addSunflowerButton:Sprite;
		
		private var bevelFilter:BitmapFilter;
		private var buttonFilters:Array = new Array();
		
		private var selection:Sprite;
		private var addBtnSelection:Sprite;

		public function Toolbar()
		{
			// create filters
			bevelFilter = new BevelFilter(2, 45, 0xCCCCCC, 0.8, 0x000000, 0.8, 5, 5, 1, BitmapFilterQuality.HIGH);
			buttonFilters.push(bevelFilter);
			
			// border for selected button
			selection = new Sprite();
			selection.graphics.lineStyle(2, 0x0066FF, 0.8);
			selection.graphics.drawRoundRect(0, 0, Constants.BUTTON_WIDTH, Constants.BUTTON_HEIGHT, 15);
			
			// the same for "Add potato", "Add Clover" and "Add Sunflower" buttons
			addBtnSelection = new Sprite();
			addBtnSelection.graphics.lineStyle(2, 0x0066FF, 0.8);
			addBtnSelection.graphics.drawRoundRect(0, 0, Constants.BUTTON_WIDTH, Constants.BUTTON_HEIGHT, 15);
			
			// toolbar background
			var loader:Loader = new Loader();
			this.addChild(loader);
			loader.load(new URLRequest(Constants.SERVER_URL + Constants.TOOLBAR_BACKGROUND_URL));
			
			// create buttons
			moveButton = createButton(20, moveButtonClick, 5, 5, Constants.MOVE_BTN_BACKGROUND_URL);
			addButton = createButton(110, addButtonClick, 5, 10, Constants.ADD_BTN_BACKGROUND_URL);
			removeButton = createButton(200, removeButtonClick, 5, 10, Constants.REMOVE_BTN_BACKGROUND_URL);
			harvestButton = createButton(290, harvestButtonClick, 5, 15, Constants.HARVEST_BTN_BACKGROUND_URL);
			nextStepButton = createButton(380, nextStepButtonClick, 5, 15, Constants.NEXTSTEP_BTN_BACKGROUND_URL);
			addPotatoButton = createButton(470, addPotatoButtonClick, 5, 15, Constants.ADD_BTN_BACKGROUND_URL, false);
			addCloverButton = createButton(560, addCloverButtonClick, 5, 15, Constants.ADD_CLOVER_BTN_BACKGROUND_URL, false);
			addSunflowerButton = createButton(650, addSunflowerButtonClick, 10, 5, Constants.ADD_SUNFLOWER_BTN_BACKGROUND_URL, false);

			// select buttons
			moveButton.addChild(selection);
			addPotatoButton.addChild(addBtnSelection);
		}
		
		private function createButton(x:int, clickListener:Function, iconX:int, iconY:int, 
									  icon:String, visible:Boolean = true):Sprite
		{
			var button:Sprite = new Sprite();
			button.x = x;
			button.y = Constants.TOP_MARGIN;
			
			// draw buttons
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(Constants.BUTTON_WIDTH, Constants.BUTTON_HEIGHT, Math.PI / 2);
			button.graphics.beginGradientFill(GradientType.LINEAR, [0xEEEEEE, 0x79ae6a], [0.4,0.9], [0,127], matrix);
			button.graphics.drawRoundRect(0, 0, Constants.BUTTON_WIDTH, Constants.BUTTON_HEIGHT, 15);
			button.graphics.endFill();
			button.filters = buttonFilters;
			
			button.visible = visible;
			button.addEventListener(MouseEvent.CLICK, clickListener);

			this.addChild(button);
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest(Constants.SERVER_URL + icon));
			loader.x = iconX;
			loader.y = iconY;
			button.addChild(loader);
			
			return button;
		}
		
		/* button click handlers */
		private function moveButtonClick(event:MouseEvent):void
		{
			selection.parent.removeChild(selection);
			moveButton.addChild(selection);
			
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).setState(Constants.MOVE_STATE);
		}
		
		private function addButtonClick(event:MouseEvent):void
		{
            selection.parent.removeChild(selection);
			addButton.addChild(selection);
			
			addBtnSelection.parent.removeChild(addBtnSelection);
			addPotatoButton.addChild(addBtnSelection);
			
			addPotatoButton.visible = true;
			addCloverButton.visible = true;
			addSunflowerButton.visible = true;
			
			(this.parent as Farm).setState(Constants.ADD_STATE);
			(this.parent as Farm).setSelectedVegType(Constants.POTATO);
		}
		
		private function addPotatoButtonClick(event:MouseEvent):void
		{
			addBtnSelection.parent.removeChild(addBtnSelection);
			addPotatoButton.addChild(addBtnSelection);
			
			(this.parent as Farm).setSelectedVegType(Constants.POTATO);
		}
		
		private function addCloverButtonClick(event:MouseEvent):void
		{
			addBtnSelection.parent.removeChild(addBtnSelection);
			addCloverButton.addChild(addBtnSelection);
			
			(this.parent as Farm).setSelectedVegType(Constants.CLOVER);
		}
		
		private function addSunflowerButtonClick(event:MouseEvent):void
		{
			addBtnSelection.parent.removeChild(addBtnSelection);
			addSunflowerButton.addChild(addBtnSelection);
			
			(this.parent as Farm).setSelectedVegType(Constants.SUNFLOWER);
		}
		
		private function removeButtonClick(event:MouseEvent):void
		{
			selection.parent.removeChild(selection);
			removeButton.addChild(selection);
			
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).setState(Constants.REMOVE_STATE);
		}
		
		private function harvestButtonClick(event:MouseEvent):void
		{
			selection.parent.removeChild(selection);
			harvestButton.addChild(selection);
			
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).setState(Constants.HARVEST_STATE);
		}
		
		private function nextStepButtonClick(event:MouseEvent):void
		{
			selection.parent.removeChild(selection);
			moveButton.addChild(selection);
			
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).setState(Constants.MOVE_STATE);
			(this.parent as Farm).controller.nextStep();
		}
	}
}
