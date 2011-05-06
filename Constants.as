package
{
	public class Constants
	{
		/* toolbar */
		public static const TOOLBAR_HEIGHT:int = 100;
		public static const BUTTON_WIDTH:int = 70;
		public static const BUTTON_HEIGHT:int = 70;
		public static const TOP_MARGIN:int = 15;
		
		/* states */
		public static const MOVE_STATE:String = "move";
		public static const ADD_STATE:String = "add";
		public static const HARVEST_STATE:String = "harvest";
		
		/* vegetable types */
		public static const POTATO:String = "potato";
		public static const CLOVER:String = "clover";
		public static const SUNFLOWER:String = "sunflower";
		
		/* requests */
		public static const COMMAND_PARAMETER:String = "command=";
		public static const GET_IMAGE_REQUEST:XML = <command name="getImage" type="" stage="" />;
		public static const GET_FIELD_REQUEST:XML = <command name="getField" />;
		public static const NEXT_STEP_REQUEST:XML = <command name="nextStep" />;
		public static const DELETE_VEGETABLE_REQUEST:XML = <command name="delVegetable"><vegetable id="" /></command>;
		public static const ADD_VEGETABLE_REQUEST:XML = <command name="addVegetable"><vegetable type="" row="" column="" /></command>;
		
		/* names of responce commands */
		public static const FIELD_RESPONCE:String = "field";
		public static const VEGETABLE_ADDED_RESPONCE:String = "vegetableAdded";
		public static const VEGETABLE_DELETED_RESPONCE:String = "vegetableDeleted";
		public static const NEXT_STEP_RESPONCE:String = "nextStep";
		public static const ERROR_RESPONCE:String = "error";
		
		/* URLs */
		public static const SERVER_URL:String = "http://localhost:3000/";
		public static const MAIN_CONTROLLER_URL:String = "request/main";
		public static const FIELD_BACKGROUND_URL:String = "images/BG.jpg";
		public static const TOOLBAR_BACKGROUND_URL:String = "images/toolbar.jpg";
		public static const MOVE_BTN_BACKGROUND_URL:String = "images/move.png";
		public static const ADD_BTN_BACKGROUND_URL:String = "images/add.png";
		public static const HARVEST_BTN_BACKGROUND_URL:String = "images/harvest.png";
		public static const NEXTSTEP_BTN_BACKGROUND_URL:String = "images/nextStep.png";
		public static const ADD_SUNFLOWER_BTN_BACKGROUND_URL:String = "images/add_sunflower.png";
		public static const ADD_CLOVER_BTN_BACKGROUND_URL:String = "images/add_clover.png";
		
		/* field constants*/
		public static const FIELD_X0_PX:int = 120;
		public static const FIELD_Y0_PX:int = 432;
		public static const ROW_COUNT:int = 11;
		public static const COL_COUNT:int = 11;
		public static const ROW_HEIGHT:int = 80;
		public static const COL_WIDTH:int = 80;
		public static const ROTATE_ANGLE:Number = 0.7854;
		public static const COMPRESSION:Number = 0.5181;
		
		public static const VEGETABLE_X_OFFSET:int = 8;
	}
}
