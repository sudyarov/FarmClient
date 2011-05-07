package views
{
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.display.Graphics;
	import flash.filters.BitmapFilterType;

	public class Toolbar extends Sprite
	{
		private var moveButton:Sprite;
		private var addButton:Sprite;
		private var harvestButton:Sprite;
		private var nextStepButton:Sprite;
		
		private var addPotatoButton:Sprite;
		private var addCloverButton:Sprite;
		private var addSunflowerButton:Sprite;
		
		private var buttonFilters:Array = new Array();
		
	/*
            var color:Number = 0x33CCFF;
            var alpha:Number = 0.8;
            var blurX:Number = 15;
            var blurY:Number = 15;
            var strength:Number = 2;
            var inner:Boolean = true;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
								  */


		public function Toolbar()
		{
			// create filters
			buttonFilters.push(new BevelFilter(2, 45, 0xCCCCCC, 0.8, 0x000000, 0.8, 5, 5, 1, BitmapFilterQuality.HIGH));
			
			var loader:Loader = new Loader();
			this.addChild(loader);
			loader.load(new URLRequest(Constants.SERVER_URL + Constants.TOOLBAR_BACKGROUND_URL));
			
			moveButton = createButton(20, moveButtonClick, 5, 5, Constants.MOVE_BTN_BACKGROUND_URL);
			addButton = createButton(110, addButtonClick, 5, 10, Constants.ADD_BTN_BACKGROUND_URL);
			harvestButton = createButton(200, harvestButtonClick, 5, 15, Constants.HARVEST_BTN_BACKGROUND_URL);
			nextStepButton = createButton(290, nextStepButtonClick, 5, 15, Constants.NEXTSTEP_BTN_BACKGROUND_URL);
			addPotatoButton = createButton(450, addPotatoButtonClick, 5, 15, Constants.ADD_BTN_BACKGROUND_URL, false);
			addCloverButton = createButton(540, addCloverButtonClick, 5, 15, Constants.ADD_CLOVER_BTN_BACKGROUND_URL, false);
			addSunflowerButton = createButton(630, addSunflowerButtonClick, 10, 5, Constants.ADD_SUNFLOWER_BTN_BACKGROUND_URL, false);

			//moveButton.emphasized = true;
		}
		
		private function createButton(x:int, clickListener:Function, iconX:int, iconY:int, 
									  icon:String, visible:Boolean = true):Sprite
		{
			var button:Sprite = new Sprite();
			button.x = x;
			button.y = Constants.TOP_MARGIN;
			
			button.graphics.lineStyle(0xFFFFFFFF, 3);
			button.graphics.beginFill(0x79ae6a);
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
		
		private function moveButtonClick(event:MouseEvent):void
		{
			/*
			moveButton.emphasized = true;
			addButton.emphasized = false;
			harvestButton.emphasized = false;
			*/
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).currentState = Constants.MOVE_STATE;
		}
		
		private function addButtonClick(event:MouseEvent):void
		{
            /*
			moveButton.emphasized = false;
			addButton.emphasized = true;
			harvestButton.emphasized = false;
			
			addPotatoButton.emphasized = true;
			addCloverButton.emphasized = false;
			addSunflowerButton.emphasized = false;
			*/
			addPotatoButton.visible = true;
			addCloverButton.visible = true;
			addSunflowerButton.visible = true;
			
			(this.parent as Farm).currentState = Constants.ADD_STATE;
			(this.parent as Farm).selectedVegType = Constants.POTATO;
		}
		
		private function addPotatoButtonClick(event:MouseEvent):void
		{
			/*
			addPotatoButton.emphasized = true;
			addCloverButton.emphasized = false;
			addSunflowerButton.emphasized = false;
			*/
			(this.parent as Farm).selectedVegType = Constants.POTATO;
			
		}
		
		private function addCloverButtonClick(event:MouseEvent):void
		{
			/*
			addPotatoButton.emphasized = false;
			addCloverButton.emphasized = true;
			addSunflowerButton.emphasized = false;
			*/
			(this.parent as Farm).selectedVegType = Constants.CLOVER;
		}
		
		private function addSunflowerButtonClick(event:MouseEvent):void
		{
			/*
			addPotatoButton.emphasized = false;
			addCloverButton.emphasized = false;
			addSunflowerButton.emphasized = true;
			*/
			(this.parent as Farm).selectedVegType = Constants.SUNFLOWER;
		}
		
		private function harvestButtonClick(event:MouseEvent):void
		{
			/*
			moveButton.emphasized = false;
			addButton.emphasized = false;
			harvestButton.emphasized = true;
			*/
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).currentState = Constants.HARVEST_STATE;
		}
		
		private function nextStepButtonClick(event:MouseEvent):void
		{
			/*
			moveButton.emphasized = true;
			addButton.emphasized = false;
			harvestButton.emphasized = false;
			*/
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).currentState = Constants.MOVE_STATE;
			(this.parent as Farm).controller.nextStep();
		}
	}
}
