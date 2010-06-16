// I want this working like this 

// load mp3 file
// check how many data will be loaded 
// draw data on the screen

// times[i] -> time in ms
// data[i]  -> sound energy (y-axis on our graph)
// so we got some number of samples 10s mp3 ->  100 (100ms) samples 

// if graph has 800px width, and each sample has 10px width, so we could draw 800/10 = 80 samples it's mean 8s mp3

// if we add sampleShift variable, we could rewind, and go forward through all mp3 if it's longer then 8s

package {

import bridge.FABridge;
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
import flash.text.TextField;
import flash.text.TextFormat;
//import mx.core.UIComponent;

public class FragmentPlayer extends Sprite {
        private var graphWidth:int=1024;
        private var graphHeight:int=100;
        private var externalBridge:FABridge;
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
        private var sampleWidth:Number = 4; // how big will be ~100ms fragment on the screen (px)
        private var sampleShift:int = 0; // this is index for data and times table that we add all the time
        private var totalLength:Number; // lenght of sound in pixels
        public var sStart:int = 0;
        public var sEnd:int = 0;

        private var snd:Sound;
        private var req:URLRequest;
        
        private var background:Sprite;
        private var positionBar:Sprite;
        private var beforeBar:Sprite;
        private var afterBar:Sprite;
        private var samplesToRead:Number;
        private var fragments:Array;


        public function FragmentPlayer():void {
            super();
            externalBridge = new FABridge();
            externalBridge.rootObject = this;
            background = new Sprite();
            addChild(background);
            background.addEventListener(MouseEvent.MOUSE_DOWN, startSelection);
            background.addEventListener(MouseEvent.MOUSE_UP, endSelection);

            positionBar = new Sprite();
            addChild(positionBar);

            beforeBar = new Sprite();
            afterBar = new Sprite();
            positionBar.addChild(beforeBar);
            positionBar.addChild(afterBar);   
            beforeBar.addEventListener(MouseEvent.MOUSE_DOWN, shiftLeft);
            afterBar.addEventListener(MouseEvent.MOUSE_DOWN, shiftRight);
            //audio = "assets/4bd5801037a31c7619000007.mp3";
        }
        
        public function set attachedFragments(arrayOfFragments:Array):void {
            fragments = arrayOfFragments;
            for each (var fragment:Object in fragments){
                var tf:TextField = new TextField();
                var tfo:TextFormat = new TextFormat();
                tfo.color = 0xffffff;
                fragment.textField = tf;
                tf.defaultTextFormat = tfo;
                tf.x = 0;
                tf.y = 0;
                tf.width = 100;
                tf.height = 50;
                tf.text = fragment.content;
                tf.backgroundColor = 0x000000;
                tf.background = true;
                tf.autoSize = "left";
                addChild(tf);
                tf.addEventListener(MouseEvent.CLICK, fragmentSelected);    
                trace('Adding text: '+fragment.content);
            }
        }
        private function fragmentSelected(event:MouseEvent):void {
            //event.target.background= !event.target.background;
            for each (var fragment:Object in fragments) {
                if (fragment.textField === event.target){
                    trace('Fragment_Selection: '+fragment.start+' '+fragment.end );
                    var selection:Array = timesToPixels([fragment.start,fragment.end]);
                    sStart = selection[0]*sampleWidth;
                    sEnd = selection[1]*sampleWidth;
                    playSelection();
                    drawGraph(graphWidth,graphHeight);
                    drawGraph(graphWidth,graphHeight,sStart,sEnd,0xffff00);  
                    dispatchEvent(new Event("SELECTION_CHANGED"));
                }
            }
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
                times.push(timePosition); timePosition = timePosition+92.879818594;  // ~100ms    1sample = 1000ms/44100 so 4096sample = 92.87
                sampleData.clear();
                samplesToRead = snd.extract(sampleData,4096);
            }
            // snd.extract(sampleData,samplesToRead); // ignore remaining part for now, I guess we could leave without less then 0.1s sound
            rangePeak = maxPeak - minPeak; 
            trace("You could draw graph here");
            dispatchEvent(new Event("GRAPH_READY"));
            trace("Stage size:"+stage.width+"x"+stage.height);
            channel = snd.play();
            channel.stop();
            var g:Graphics = background.graphics;
            g.clear();
            g.beginFill(0xa0a0ff);//,background_alpha);
            g.drawRect(0,0,graphWidth,graphHeight);
            g.endFill();
            drawGraph(graphWidth,graphHeight);
            trace("Graph ready");
            trace("Stage size:"+stage.width+"x"+stage.height);
            //attachedFragments = [{content:'Hello',start:10000,end:20000}];
        }
        // this is just to make things easier for javascript
        public function load(url:String):void {
            trace('loading new file');
            audio = url;
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
            drawGraph(graphWidth,graphHeight);   //this is to clean previous selection
        }
        private function endSelection(event:MouseEvent):void {
            sEnd = mouseX; //times[int(mouseX/sampleWidth)];
            if (sStart>sEnd) {
                sEnd = sStart;
                sStart = mouseX;
            }
            if (int(sEnd/sampleWidth)+sampleShift >= (times.length))
            {
                //sEnd/sampleWidth = times.length - sampleShift-1;
                sEnd = (times.length - sampleShift-1)*sampleWidth;
            }
            playSelection();
            drawGraph(graphWidth,graphHeight,sStart,sEnd+sampleWidth,0xffff00);  // sEnd+sampleWidth just to mark one bar more on the graph
            dispatchEvent(new Event("SELECTION_CHANGED"));
        }

        private function playSelection():void {
            channel.stop();
            channel = snd.play(times[int(sStart/sampleWidth)+sampleShift]);
            var timeout:int = times[int(sEnd/sampleWidth)] - times[int(sStart/sampleWidth)]; //ms
            setTimeout(channel.stop, timeout);
        }
        private function shiftLeft(event:MouseEvent):void {
           if (sampleShift >=100) {
                sampleShift = sampleShift - 100;
                 clearGraph(graphWidth,graphHeight);
                 drawGraph(graphWidth,graphHeight);
           } 
        trace("Window times:"+getWindowTimes()[0]+' '+getWindowTimes()[1]);
        }
        private function shiftRight(event:MouseEvent):void {
           if (sampleShift < (data.length-100)) {
                sampleShift = sampleShift + 100;
                clearGraph(graphWidth,graphHeight)
                drawGraph(graphWidth,graphHeight);
           } 
        trace("Window times:"+getWindowTimes()[0]+' '+getWindowTimes()[1]);
        }

        private function clearGraph(width:int, height:int):void{
            var g:Graphics = background.graphics;
                 g.clear();
                 g.beginFill(0xa0a0ff);//,background_alpha);
                 g.drawRect(0,0,width,height);
                 g.endFill();

        }
        private function playSound(event:MouseEvent):void {
            trace('restart');
            channel.stop();
            channel = snd.play(times[int(mouseX/sampleWidth)+sampleShift]);
        }
        private function drawPositionBar(width:int,height:int,sampleLength:int):void{      
            var sampleWidth:Number = width/data.length;
            positionBar.y = height; 
            var g:Graphics = positionBar.graphics;
            g.lineStyle(1, 0x000000);
            //total
            g.clear()
            g.beginFill(0x006666,1);
            g.drawRect(0,0,width,15);
            g.endFill();
            //before
            g = beforeBar.graphics;
            g.clear();
            g.beginFill(0x000000,1);
            g.drawRect(0,0,int(sampleShift*sampleWidth),15);
            g.endFill();
            //after
            g = afterBar.graphics;
            g.clear();
            g.beginFill(0x000000,1);
            g.drawRect(int((sampleShift+sampleLength)*sampleWidth),0,width-int((sampleShift+sampleLength)*sampleWidth),15);
            g.endFill();
        
        }
        public function getSelectionTimes():Array {
            return [times[int(sStart/sampleWidth)+sampleShift],times[int(sEnd/sampleWidth)+sampleShift]];
        }
        public function getWindowTimes():Array {
            var windowStart:int = sampleShift;
            if (windowStart < 0){
                windowStart = 0
            }

            var windowEnd:int = sampleShift+int(graphWidth/sampleWidth);
            if (windowEnd > data.length){
                windowEnd = data.length-1;
            }
            return [times[windowStart],times[windowEnd]];
        }
        public function timesToPixels(a:Array):Array {
            var start:int = 0;
            var end:int =0;
            for( var i:int=0;i<times.length;i++){
                if((times[i] > a[0]) && start == 0) { start = (i - sampleShift); }
                if(times[i] > a[1] ) { end = (i - sampleShift); break; } 
            }
        return [start,end];
        }
 
        private function drawGraph(width:int,height:int,start:int=0,end:int=-1,color:uint=0xbb0066):void {
            //drawing graph on screen 800x600 using volume information from data:Array
            var g:Graphics = background.graphics;
            //sampleWidth = width/data.length;
            //totalLength = data.length * sampleWidth;
            if (start != 0) {start = start / sampleWidth};
            if (end != -1) {end = end /sampleWidth} else { end = start+int(width/sampleWidth) };
            if (end+sampleShift > data.length) {
                end = data.length-sampleShift;
            }
            for (var i:int=start;i<end;i++){
                    g.lineStyle(1, 0x000000);
                    g.beginFill(color,1);  // params color, alpha
                    g.drawRect(i*sampleWidth,height,sampleWidth,int(-(data[i+sampleShift]-minPeak)*Number(height/rangePeak)));
                    g.endFill();
            }
            if (start == 0) { // when start is != 0 it's mean we draw yellow selection, so don't redraw position bar then.
                drawPositionBar(width,height,end-start);
            }
                drawFragments();
        }
        private function drawFragments():void{
            var windowTimes:Array = getWindowTimes();
            for (var i:int=0;i<fragments.length;i++){
                trace('checking if I can draw '+fragments[i].content);
                fragments[i].textField.visible = false;
                if ((fragments[i].start > windowTimes[0]) && (fragments[i].end < windowTimes[1])){
                    trace('Fragment visible:'+fragments[i].content);
                    fragments[i].textField.visible = true;
                    fragments[i].textField.x = sampleWidth*timesToPixels([fragments[i].start,fragments[i].end])[0];
                    fragments[i].textField.y = 22*(i % 3);
                }
            }
        }


    }
}
