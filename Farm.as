package
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import models.Vegetable;	
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	
	public class Farm extends Sprite
	{
		private var bgLoader:Loader;
		var controller:Controller;
		
		var potatoImages:Array = [
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
				   ];
		
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
		
		function drawVegetables():void
		{
			for (var i:int = 0; i < potatoImages.length; i++)
			{
				if (potatoImages[i].image == null)
				{
					trace("111Loading: " + potatoImages[i].path);
					var tempLoader:Loader = new Loader();
					tempLoader.load(new URLRequest(potatoImages[i].path));
					potatoImages[i].image = tempLoader;
				}
				
				var temp:Sprite = new Sprite();
				temp.x = controller.FIELD_X0_PX + i * 55;
				temp.y = controller.FIELD_Y0_PX - i * 28 - potatoImages[i].y0;
				this.addChild(temp);
				temp.addChild(potatoImages[0].image);
			}
			/*
			for (var i:int = potatoImages.length - 1; i >= 0; i--)
			{
				if (potatoImages[i].image == null)
				{
					//trace("Loading: " + potatoImages[i].path);
					var tempLoader:Loader = new Loader();
					tempLoader.load(new URLRequest(potatoImages[i].path));
					potatoImages[i].image = tempLoader;
				}
				var temp:Sprite = new Sprite();
				temp.x = controller.FIELD_X0_PX + 2 * i * 55;
				temp.y = controller.FIELD_Y0_PX - i * 28 - potatoImages[i].y0;
				this.addChild(temp);
				temp.addChild(potatoImages[i].image);
				
			}
			*/
		}
	}
}