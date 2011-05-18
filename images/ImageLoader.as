package images
{
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.events.Event;

    public class ImageLoader extends Loader
    {
        private var state:int;
        private var type:String;
        private var growthStage:int;

        private var xmlRequest:XML;
        private var request:URLRequest;

        private var _loaded:Boolean;

        public function ImageLoader()
        {
            this.xmlRequest = Constants.GET_IMAGE_REQUEST;
            request = new URLRequest(Constants.SERVER_URL + Constants.MAIN_CONTROLLER_URL);
			request.method = URLRequestMethod.POST;
        }

        public function loadImage(type:String, growthStage:int):void
        {
            this._loaded = false;
            this.type = type;
			this.growthStage = growthStage;

			this.xmlRequest.@type = type;
			this.xmlRequest.@stage = growthStage;

			request.data = Constants.COMMAND_PARAMETER + xmlRequest.toXMLString();
            this.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			load(request);
        }

        private function completeHandler(event:Event):void
        {
            _loaded = true;
        }

        /* getters */
        public function getState():int
        {
            return this.state;
        }

        public function getType():String
        {
            return this.type;
        }

        public function getGrowthStage():int
        {
            return this.growthStage;
        }

        public function loaded():Boolean
        {
            return this._loaded;
        }
    }
}
