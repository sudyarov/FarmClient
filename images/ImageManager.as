package images
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.Bitmap;

import views.MessageWindow;

public class ImageManager
    {
        private var loaders:Array;
        private var farm:Farm;
        private var messageWindow:MessageWindow;
        private var notLoadedCount:int;
        private var isNew:Boolean;

        public function ImageManager(farm:Farm)
        {
            this.farm = farm;
            messageWindow = MessageWindow.getInstance();
            loaders = new Array();
        }

        /* load images from server */
		public function getImages(notLoadedImages:Array, isNew:Boolean):void
		{
            var curPos:int;
            var isSet:Boolean;

            this.isNew = isNew;
            notLoadedCount = notLoadedImages.length;

            curPos = 0;
            for each (var image:Object in notLoadedImages)
            {
                isSet = false;
                for (; curPos < loaders.length; curPos++)
                {
                    if (loaders[curPos].loaded())
                    {
                        loaders[curPos].loadImage(image.vtype, image.growthStage);
                        isSet = true;
                        curPos++;
                        break;
                    }
                }

                if (isSet)
                    continue;

                var loader:ImageLoader = new ImageLoader();
                loaders.push(loader);
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                loader.loadImage(image.vtype, image.growthStage);
                curPos++;
            }
		}

        private function completeHandler(event:Event):void
		{
			farm.vegImages[event.currentTarget.loader.getType()][event.currentTarget.loader.getGrowthStage() - 1].image = Bitmap(event.currentTarget.content).bitmapData.clone();
            notLoadedCount--;
            if (notLoadedCount == 0)
                farm.drawVegetables(this.isNew);
		}

		private function errorHandler(event:IOErrorEvent):void
		{
			messageWindow.show(Constants.CONNECTION_LOST_MESSAGE, Constants.MW_CENTER, false);
		}
    }
}
