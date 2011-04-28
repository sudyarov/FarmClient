package
{
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import fl.controls.ButtonLabelPlacement;

	public class Toolbar extends Sprite
	{
		private var moveButton:Button;
		private var addButton:Button;
		private var harvestButton:Button;

		public function Toolbar()
		{
			var loader:Loader = new Loader();
			this.addChild(loader);
			loader.load(new URLRequest("http://localhost:3000/images/toolbar.jpg"));
			
			moveButton = new Button();
			moveButton.x = 20;
			moveButton.y = Constants.TOP_MARGIN;
			moveButton.width = Constants.BUTTON_WIDTH;
			moveButton.height = Constants.BUTTON_HEIGHT;
			moveButton.addEventListener(MouseEvent.CLICK, moveButtonClick);
			this.addChild(moveButton);
			var mloader:Loader = new Loader();
			mloader.load(new URLRequest("http://localhost:3000/images/move.png"));
			mloader.x = 5;
			mloader.y = 5;
			moveButton.addChild(mloader);
			
			addButton = new Button();
			addButton.x = 110;
			addButton.y = Constants.TOP_MARGIN;
			addButton.width = Constants.BUTTON_WIDTH;
			addButton.height = Constants.BUTTON_HEIGHT;
			addButton.addEventListener(MouseEvent.CLICK, addButtonClick);
			this.addChild(addButton);
			var aloader:Loader = new Loader();
			aloader.load(new URLRequest("http://localhost:3000/images/add.png"));
			aloader.x = 5;
			aloader.y = 10;
			addButton.addChild(aloader);
			
			harvestButton = new Button();
			harvestButton.x = 200;
			harvestButton.y = Constants.TOP_MARGIN;
			harvestButton.width = Constants.BUTTON_WIDTH;
			harvestButton.height = Constants.BUTTON_HEIGHT;
			harvestButton.addEventListener(MouseEvent.CLICK, harvestButtonClick);
			this.addChild(harvestButton);
			var hloader:Loader = new Loader();
			hloader.load(new URLRequest("http://localhost:3000/images/harvest.png"));
			hloader.x = 5;
			hloader.y = 10;
			harvestButton.addChild(hloader);
			
			moveButton.emphasized = true;
		}
		
		public function moveButtonClick(event:MouseEvent):void
		{
			moveButton.emphasized = true;
			addButton.emphasized = false;
			harvestButton.emphasized = false;
			(this.parent as Farm).currentState = Constants.MOVE_STATE;
		}
		
		public function addButtonClick(event:MouseEvent):void
		{
			moveButton.emphasized = false;
			addButton.emphasized = true;
			harvestButton.emphasized = false;
			(this.parent as Farm).currentState = Constants.ADD_STATE;
		}
		
		public function harvestButtonClick(event:MouseEvent):void
		{
			moveButton.emphasized = false;
			addButton.emphasized = false;
			harvestButton.emphasized = true;
			(this.parent as Farm).currentState = Constants.HARVEST_STATE;
		}
	}
}
