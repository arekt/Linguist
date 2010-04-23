package {

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import bridge.FABridge;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.geom.Point;

import JSONReader;
 
    public class WaveformGraph extends Sprite {
        private var externalBridge:FABridge;
        public var waveform:Array;
        public var stats:Object = new Object();
        public var wG:MovieClip  = new MovieClip();
        public var beginLabel:TextField = new TextField();
        public var fplayer:FABPlayer = new FABPlayer();
        //constructor
        public function WaveformGraph(){
            super(); //Sprite
            externalBridge = new FABridge();
            externalBridge.rootObject = this;
            addChild(wG);
            beginLabel.text='()';
            beginLabel.textColor=0xffffff;
            var tf:TextFormat=beginLabel.defaultTextFormat;
            tf.size = 20;
            beginLabel.height = tf.size + 5
            beginLabel.defaultTextFormat=tf;
            beginLabel.x=0;
            beginLabel.y=0;
            beginLabel.selectable=false;
            addChild(beginLabel);
        //    load('/waveform/5');
        }
        public function load(url:String):void {
            var jR:JSONReader = new JSONReader(url);
            jR.addEventListener(Event.COMPLETE, dataReady);
        }
        public function dataReady(event:Event):void {
           trace("This has been read from JSON: waveform[0] (value,time) ");
           trace(event.currentTarget.result.waveform[0].value+' '+event.currentTarget.result.waveform[0].time);
           waveform = event.currentTarget.result.waveform;
           stats = event.currentTarget.result.stats; // "stats":{"minValue":2,"maxValue":61,"maxTime":138580}
//           drawSoundWindow(Math.round(stage.stageWidth*Number(1024/stage.stageWidth)),stage.stageHeight*(50/stage.stageHeight),0,20000);          
           drawSoundWindow(1024,stats.maxValue,0,20000);
           wG.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
           wG.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler); 
        }
        private function find_wf_index(time:Number):Number{
            for (var i:Number=0;i<(waveform.length);i++){
                if (waveform[i].time > time) { return i>1?(i-1):0}
            }
            return i;
        }
        private function find_wf_index_max():Number{
            var i:Number = waveform.length-1;
            return i;
        }
         
        public function drawSoundWindow(dWidth:Number,dHeight:Number,wfWindow_start:Number,wfWindow_stop:Number):void
        {
                //miliseconds of mp3
                stats.dWidth = dWidth;
                stats.dHeight = dHeight;
                stats.window_start = wfWindow_start;
                stats.window_stop = wfWindow_stop;
                stats.window_width = wfWindow_stop - wfWindow_start;
                //indexes of waveform array
                stats.index_start = find_wf_index(stats.window_start);
                stats.index_stop = find_wf_index(stats.window_stop);
                stats.index_width = stats.index_stop - stats.index_start;
                //how much pixels on the screen need one alement from waveform array
                stats.pixel_width = Math.round(dWidth/stats.index_width); // we lost here couple of pixels because one index is not equal the same amount of time
                // so we need calculate new stats.index_stop in loop froough all values or maybe better we modify for loop which draw
                stats.pixel_height = 1; //dHeight/(stats.maxValue-stats.minValue);
                 
                wG.graphics.clear();
                wG.graphics.lineStyle(1,0x000000);
                wG.graphics.beginFill(0xa0a0f0,0);
                wG.graphics.drawRect(0,0,dWidth,dHeight);
                wG.graphics.endFill();
                for (var i:Number=stats.index_start;i<stats.index_stop;i++){
    //          var currentWidth:Number = 0;
    //          for (var i:Number=stats.index_start;currentWidth < dWidth ;i++){
    //            currentWidth += stats.pixel_width;
                wG.graphics.beginFill(0xFFFF00);
                wG.graphics.drawRect((i-stats.index_start)*stats.pixel_width,stats.dHeight,stats.pixel_width,Math.round((waveform[i].value-stats.minValue)*stats.pixel_height)-stats.dHeight);
//                trace('***stats.minValue,stats.maxValue',stats.minValue,' ',stats.maxValue,' ',waveform[i].value);
//                wG.graphics.drawRect(
//                (i-stats.index_start)*stats.pixel_width,
//                dHeight,
//                stats.pixel_width,
//                -(dHeight-waveform[i].value));
                wG.graphics.endFill();
                beginLabel.text = '('+stats.window_start+')';
            }
        }
        public function forward():void{
            var skip:Number = Math.round(stats.window_width/2);
            var new_window_start:Number = stats.window_start+skip;
            var new_window_stop:Number = stats.window_stop+skip;
            trace('maxTime:',stats.maxTime, 'nw_stop: ',new_window_stop);
                if (new_window_stop > stats.maxTime) {
                    new_window_stop = stats.maxTime; 
                    new_window_start = stats.maxTime - 20000;
                }
                drawSoundWindow(stats.dWidth,stats.dHeight,new_window_start,new_window_stop);
                draw_selection();
        }
        public function backward():void{
            var skip:Number = Math.round(stats.window_width/2);
                var new_window_start:Number = stats.window_start-skip;
                var new_window_stop:Number = stats.window_stop-skip;
                if (new_window_start < 0 ) {
                    new_window_start = 0;
                    new_window_stop = 20000;
                }
                drawSoundWindow(stats.dWidth,stats.dHeight,new_window_start,new_window_stop);
                draw_selection();
        }

        public function redraw():void{
                trace('***redraw params:',stats.dWidth,stats.dHeight,stats.window_start,stats.window_stop);
                drawSoundWindow(stats.dWidth,stats.dHeight,stats.window_start,stats.window_stop-1);
                trace('****After redraw');
        }
        public function draw_selection():void{
            trace('***begin draw selection');
            redraw(); //clean previous selection
            wG.graphics.lineStyle(1,0x000000);
            for (var i:Number=stats.selection_start;i<stats.selection_stop;i++){
            wG.graphics.beginFill(0x00f0f0);
            trace('inside for loop');
            trace(stats.index_start,stats.pixel_width,stats.dHeight,waveform[i]);
            wG.graphics.drawRect((i-stats.index_start)*stats.pixel_width,stats.dHeight,stats.pixel_width,Math.round((waveform[i].value-stats.minValue)*stats.pixel_height)-stats.dHeight);
//            wG.graphics.drawRect((i-stats.index_start)*stats.pixel_width,stats.dHeight-Math.round((waveform[i].value-stats.minValue)*stats.pixel_height),stats.pixel_width,Math.round((waveform[i].value-stats.minValue)*stats.pixel_height));
            //wG.graphics.drawRect(
             //   (i-stats.index_start)*stats.pixel_width,
            //    dHeight,
            //    stats.pixel_width,
            //    -(dHeight-waveform[i].value));

            wG.graphics.endFill();
            }
        }
        private function onMouseDownHandler(evt:MouseEvent):void{
            stats.selection_start = pixel2waveformIndex(evt.target.mouseX);
            stats.selection_start_time = waveform[stats.selection_start].time;
            trace('start t.target.mouseX:',evt.target.mouseX);
            trace('selection_start:',waveform[stats.selection_start].time);
            trace('Mouse down');
        }
        private function onMouseUpHandler(evt:MouseEvent):void{
            trace('Mouse up');
            stats.selection_stop = pixel2waveformIndex(evt.target.mouseX);
            trace('stop vt.target.mouseX:',evt.target.mouseX);
            stats.selection_stop_time = waveform[stats.selection_stop].time;
            trace('selection_stop:',waveform[stats.selection_stop].time);
            //var duration:Number = waveform[stats.selection_stop].time - waveform[stats.selection_start].time;
            //mp3player.play(mp3File,waveform[stats.selection_start].time,duration);
            //selectionReady();
            dispatchEvent(new Event(Event.CHANGE));
            draw_selection();
        }
        private function pixel2waveformIndex(x:Number):Number{
        var waveformIndex:Number = Math.round(x/stats.pixel_width)+stats.index_start;
        if ( waveformIndex >= waveform.lenght ) {
            waveformIndex =  waveform.lenght-1;
        }
        trace ('**return pixel2waveformIndex:',waveformIndex );
        return waveformIndex; 
        }
    }
}
