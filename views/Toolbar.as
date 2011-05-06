package views
{
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;

public class Toolbar extends Sprite
	{
		private var moveButton:SimpleButton;
		private var addButton:SimpleButton;
		private var harvestButton:SimpleButton;
		private var nextStepButton:SimpleButton;
		
		private var addPotatoButton:SimpleButton;
		private var addCloverButton:SimpleButton;
		private var addSunflowerButton:SimpleButton;

		public function Toolbar()
		{
			var loader:Loader = new Loader();
			this.addChild(loader);
			loader.load(new URLRequest(Constants.SERVER_URL + Constants.TOOLBAR_BACKGROUND_URL));
			/*
			moveButton = createButton(moveButton, 20, moveButtonClick);
			var mloader:Loader = new Loader();
			mloader.load(new URLRequest(Constants.SERVER_URL + Constants.MOVE_BTN_BACKGROUND_URL));
			mloader.x = 5;
			mloader.y = 5;
			moveButton.addChild(mloader);
			*/
            var aloader:Loader = new Loader();
			aloader.load(new URLRequest(Constants.SERVER_URL + Constants.ADD_BTN_BACKGROUND_URL));
			aloader.x = 5;
			aloader.y = 10;
			this.addChild(aloader);
			addButton = createButton(addButton, 0, addButtonClick);

			/*
			harvestButton = createButton(harvestButton, 200, harvestButtonClick);
            var hloader:Loader = load_button_image(5, 15);
            harvestButton.addChild(hloader);

			nextStepButton = createButton(nextStepButton, 290, nextStepButtonClick);
			var nsloader:Loader = new Loader();
			nsloader.load(new URLRequest(Constants.SERVER_URL + Constants.NEXTSTEP_BTN_BACKGROUND_URL));
			nsloader.x = 5;
			nsloader.y = 15;
			nextStepButton.addChild(nsloader);
			
			addPotatoButton = createButton(addPotatoButton, 450, addPotatoButtonClick, false);
			var aploader:Loader = new Loader();
			aploader.load(new URLRequest(Constants.SERVER_URL + Constants.ADD_BTN_BACKGROUND_URL));
			aploader.x = 5;
			aploader.y = 15;
			addPotatoButton.addChild(aploader);
			
			addCloverButton = createButton(addCloverButton, 540, addCloverButtonClick, false);
			var acloader:Loader = new Loader();
			acloader.load(new URLRequest(Constants.SERVER_URL + Constants.ADD_CLOVER_BTN_BACKGROUND_URL));
			acloader.x = 5;
			acloader.y = 15;
			addCloverButton.addChild(acloader);
			
			addSunflowerButton = createButton(addSunflowerButton, 630, addSunflowerButtonClick, false);
			var asloader:Loader = new Loader();
			asloader.load(new URLRequest(Constants.SERVER_URL + Constants.ADD_SUNFLOWER_BTN_BACKGROUND_URL));
			asloader.x = 10;
			asloader.y = 5;
			addSunflowerButton.addChild(asloader);
			*/
			//moveButton.emphasized = true;
		}

    private function load_button_image(x:int, y:int ):Loader {
        var hloader:Loader = new Loader();
        hloader.load(new URLRequest(Constants.SERVER_URL + Constants.HARVEST_BTN_BACKGROUND_URL));
        hloader.x = x;
        hloader.y = y;
        return hloader;
    }
		
		private function createButton(button: SimpleButton, x:int, clickListener:Function,
									  visible:Boolean = true, label:String = ""):SimpleButton
		{
			button = new SimpleButton();
			//button.label = label;
			button.x = x;
			button.y = Constants.TOP_MARGIN;
			button.width = Constants.BUTTON_WIDTH;
			button.height = Constants.BUTTON_HEIGHT;
			button.visible = visible;
			button.addEventListener(MouseEvent.CLICK, clickListener);
			this.addChild(button);
			
			return button;
		}
		/*
		private function moveButtonClick(event:MouseEvent):void
		{
			moveButton.emphasized = true;
			addButton.emphasized = false;
			harvestButton.emphasized = false;
			
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).currentState = Constants.MOVE_STATE;
		}
		*/
		private function addButtonClick(event:MouseEvent):void
		{
            /*
			moveButton.emphasized = false;
			addButton.emphasized = true;
			harvestButton.emphasized = false;
			
			addPotatoButton.visible = true;
			addPotatoButton.emphasized = true;
			addCloverButton.visible = true;
			addCloverButton.emphasized = false;
			addSunflowerButton.visible = true;
			addSunflowerButton.emphasized = false;
			
			(this.parent as Farm).currentState = Constants.ADD_STATE;
			(this.parent as Farm).selectedVegType = Constants.POTATO;
			*/
		}
		/*
		private function addPotatoButtonClick(event:MouseEvent):void
		{
			addPotatoButton.emphasized = true;
			addCloverButton.emphasized = false;
			addSunflowerButton.emphasized = false;
			
			(this.parent as Farm).selectedVegType = Constants.POTATO;
		}
		
		private function addCloverButtonClick(event:MouseEvent):void
		{
			addPotatoButton.emphasized = false;
			addCloverButton.emphasized = true;
			addSunflowerButton.emphasized = false;
			
			(this.parent as Farm).selectedVegType = Constants.CLOVER;
		}
		
		private function addSunflowerButtonClick(event:MouseEvent):void
		{
			addPotatoButton.emphasized = false;
			addCloverButton.emphasized = false;
			addSunflowerButton.emphasized = true;
			
			(this.parent as Farm).selectedVegType = Constants.SUNFLOWER;
		}
		
		private function harvestButtonClick(event:MouseEvent):void
		{
			moveButton.emphasized = false;
			addButton.emphasized = false;
			harvestButton.emphasized = true;
			
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).currentState = Constants.HARVEST_STATE;
		}
		
		private function nextStepButtonClick(event:MouseEvent):void
		{
			moveButton.emphasized = true;
			addButton.emphasized = false;
			harvestButton.emphasized = false;
			
			addPotatoButton.visible = false;
			addCloverButton.visible = false;
			addSunflowerButton.visible = false;
			
			(this.parent as Farm).currentState = Constants.MOVE_STATE;
			(this.parent as Farm).controller.nextStep();
		}
    */
	}
}
