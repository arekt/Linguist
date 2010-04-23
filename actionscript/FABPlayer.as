
package {
    import flash.text.TextField;
	import flash.display.MovieClip;
	//import bridge.FABridge;
	import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.Timer;

	public class FABPlayer extends MovieClip {
		
		//private var externalBridge:FABridge;
        private var t:TextField = new TextField();		
        internal var sTimer:Timer = new Timer(1000,1);
        internal var sndChannel:SoundChannel;
        internal var audio:Object = new Object();

		public function FABPlayer() {
			super();
            sTimer.addEventListener(TimerEvent.TIMER, stopAudio);
			//externalBridge = new FABridge();
			//externalBridge.rootObject = this;
            t.text = "";
            t.width = 200;
            t.height = 50;
            t.x = 0;
            t.y = 0;
            addChild(t);
		}
        public function playMP3(filename:String,start:int,duration:int,info:String=""):void {
            trace('Start playing mp3: ',filename,' ',start,' ',duration);
            if (audio.name != filename){
                trace('********** Loading audio');
                audio.sound = new Sound();
                audio.sound.load(new URLRequest(filename));
                audio.name = filename;
                audio.loaded = false;
                audio.sound.addEventListener(Event.COMPLETE,function(event:Event):void{ 
                    audio.loaded = true; playSound(start,duration);
                    }); 
                audio.sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                t.text = info;
            } 
            if (audio.loaded) 
                playSound(start,duration);
        }

        private function playSound(start:int,duration:int):void {
                trace("playing file"+audio.name+"start: "+start);
                if(sndChannel){ sndChannel.stop();}; 
                sTimer.delay = duration;
                sTimer.reset();
                sndChannel=audio.sound.play(start);
                sTimer.start();
        }

        private function stopAudio(event:*):void {
            if(sndChannel){ 
                trace("stopping file", audio.name);
                sndChannel.stop();
                };
        }

        private function errorHandler(errorEvent:IOErrorEvent):void {
             t.text = "The sound could not be loaded: " + errorEvent.text;
        } 
	}
}
