package {

import com.adobe.serialization.json.JSON;
import flash.net.URLLoader; 
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.EventDispatcher;
 
    public class JSONReader extends EventDispatcher{
        public var result:Object;
        private var request:URLRequest;
        private var loader:URLLoader = new URLLoader();
        //constructor
        public function JSONReader (url:String):void {
            super();
            request = new URLRequest(url);
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE, parseJSON); 
            try 
            { 
                loader.load(request); 
            }  
            catch (error:Error) 
            { 
                trace("Unable to load URL: " + error); 
            } 
        }
        //TODO add error handler
        internal function parseJSON (event:Event):void{
            trace("RawJsonData (before parse)");
            trace(event.target.data);
            result = JSON.decode(String(event.target.data));
            trace('dispatch EVENT');
            dispatchEvent(new Event(Event.COMPLETE));     
        }
    }
}
