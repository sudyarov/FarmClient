package views
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class MessageWindow extends TextField
	{
		private static var instance:MessageWindow = new MessageWindow();
		private var timer:Timer;
		
		public function MessageWindow()
		{
			if (instance)
				throw new Error();
				
			this.visible = false;

			// setting displaying options
			background = true;
			backgroundColor = 0xEEEEEE;
			this.textColor = 0xEE3333;
			border = true;
			autoSize = TextFieldAutoSize.CENTER;
			selectable = false;
			
			// create timer and set handler
			timer = new Timer(5000, 1);
			timer.addEventListener(TimerEvent.TIMER, hide);
		}
		
		public static function getInstance():MessageWindow
		{
			return instance;
		}
		
		public function show(message:String, position:String, closeOnTimer:Boolean):void
		{
			text = message;
			
			// positioning "window"
			if (position == Constants.MW_CENTER)
			{
				this.x = (stage.stageWidth - this.width) / 2;
				this.y = (stage.stageHeight - this.height) / 2;
			}
			else if (position == Constants.MW_BOTTOM_LEFT)
			{
				this.x = 0;
				this.y = stage.stageHeight - this.height;
			}
			
			// start/restart timer if closeOnTimer is set to TRUE
			if (closeOnTimer)
			{
				if (timer.running)
					timer.stop();
				timer.start();
			}
			
			this.visible = true;
		}
		
		private function hide(event:TimerEvent):void
		{
			this.visible = false;
		}
	}
}
