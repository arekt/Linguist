// This is working like that:
// 1. Read sound file,
// 2. Play file  ( problem we don't finish for all sound loaded )  
// when sound is playing on each frame we store some data (Array) and times (Array) in Event.ENTER_FRAME -> on EnterFrame
// 3. when sound reading will finish (Event.SOUND_COMPLETE) -> onPlaybackComplete
// we remove SOUND_CMPLETE event
// we remove ENTER_FRAME event
// we draw plot of sound using data and times arrays
// ... so each subsequent invoke of snd.play() just play the sound nothing more


// I want this working like this 

// load mp3 file
// check how many data will be loaded 
// draw data on the screen


package {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.net.URLRequest;
import flash.utils.getTimer;
import flash.utils.setTimeout;
import flash.utils.ByteArray;
//import mx.core.UIComponent;


public class FragmentPlayer extends Sprite {
        private var background_alpha:Number=1;
        private var sampleData:ByteArray;
        private var data:Array;
        private var times:Array;
        private var channel:SoundChannel;
        private var lastPosition:Number = 0;
        private var averagePeak:Number = 0;
        private var maxPeak:Number = 0;
        private var minPeak:Number = 1;
        private var rangePeak:Number = 0;
        private var numberOfSamples:int = 0;
        private var sampleWidth:Number = 10; // how big will be 100ms fragment on the screen (px)
        private var totalLength:Number; // lenght of sound in pixels
        private var sStart:int = 0;
        private var sEnd:int = 0;

        private var snd:Sound;
        private var req:URLRequest;
        
        private var background:Sprite;
        private var samplesToRead:Number;

        public function FragmentPlayer():void {
            background = new Sprite();
            addChild(background);
            background.addEventListener(MouseEvent.MOUSE_DOWN, startSelection);
            background.addEventListener(MouseEvent.MOUSE_UP, endSelection);
            audio = "Kamisama_page1.mp3";
        }

        public function set backgroundAlpha(value:String):void {
            background_alpha = Number(value);
        }
        public function set audio(file:String):void {
            sampleData = new ByteArray();
            times = new Array();
            data = new Array();
            req = new URLRequest(file);
            snd = new Sound();
            snd.load(req);
            //snd.extract(bytes, 4096); // test
            snd.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            snd.addEventListener(Event.COMPLETE, onLoadComplete);

            this.graphics.clear();
        }
        private function onLoadComplete(event:Event):void {
            var averSV:Number;
            var timePosition:Number = -100;
            samplesToRead = snd.extract(sampleData,4096);
            trace("Before while; Samples to read:"+samplesToRead);
            while (samplesToRead >= 4096) {
                sampleData.position = 0;
                averSV=0;
                var n:int = 0;
                while (sampleData.bytesAvailable > 0) {
                    n=n+1;
                    //trace("Left: "+sampleData.readFloat());
                    averSV=averSV+Math.abs(sampleData.readFloat()); // right channel        
                }    
                averSV = averSV/4096;
                data.push(averSV); 
                if (averSV > maxPeak) { maxPeak = averSV }
                if (averSV < minPeak) { minPeak = averSV }

                trace(timePosition+averSV);
                times.push(timePosition); timePosition = timePosition+100;  // 100ms 
                sampleData.clear();
                samplesToRead = snd.extract(sampleData,4096);
            }
            // snd.extract(sampleData,samplesToRead); // ignore remaining part for now, I guess we could leave without less then 0.1s sound
            rangePeak = maxPeak - minPeak; 
            trace("You could draw graph here")
            channel = snd.play();
            channel.stop();
            var g:Graphics = background.graphics;
            g.clear();
            g.beginFill(0xa0a0ff);//,background_alpha);
            g.drawRect(0,0,800,200);
            g.endFill();
            drawGraph(800,200);
        }

        private function progressHandler(event:ProgressEvent):void {
            var loadTime:Number = event.bytesLoaded / event.bytesTotal;
            var LoadPercent:uint = Math.round(100 * loadTime);
              
            trace( "Sound file's size in bytes: " + event.bytesTotal + "\n" 
                                 + "Bytes being loaded: " + event.bytesLoaded + "\n" 
                                 + "Percentage of sound file that is loaded " + LoadPercent + "%.\n")
        }

        private function startSelection(event:MouseEvent):void {
            sStart = mouseX; //times[int(mouseX/sampleWidth)];
            drawGraph(800,200);
        }
        private function endSelection(event:MouseEvent):void {
            sEnd = mouseX; //times[int(mouseX/sampleWidth)];
            channel.stop();
            channel = snd.play(times[int(sStart/sampleWidth)]);
            var timeout:int = times[int(sEnd/sampleWidth)] - times[int(sStart/sampleWidth)]; //ms
            trace('timeout:',timeout, int(sEnd/sampleWidth), int(sStart/sampleWidth) );
            setTimeout(channel.stop, timeout);
            drawGraph(800,200,sStart,sEnd,0xffff00);
        }
        
        private function playSound(event:MouseEvent):void {
            trace('restart');
            channel.stop();
            channel = snd.play(times[int(mouseX/sampleWidth)]);
        }
        
        private function drawGraph(width:int,height:int,start:int=0,end:int=-1,color:uint=0xbb0066):void {
            //drawing graph on screen 800x600 using volume information from data:Array
            trace('Drawing:', start, end, color);
            var g:Graphics = background.graphics;
            //sampleWidth = width/data.length;
            totalLength = data.length * sampleWidth;
            if (start != 0) {start = start / sampleWidth};
            if (end != -1) {end = end /sampleWidth} else { end = data.length };
            trace('sWidth',sampleWidth);
            for (var i:int=start;i<end;i++){
                    g.lineStyle(1, 0x000000);
                    g.beginFill(color,1);  // params color, alpha
                    g.drawRect(i*sampleWidth,height,sampleWidth,-(data[i]-minPeak)*(height/rangePeak));
                    g.endFill();
            }
        }
    }
}
