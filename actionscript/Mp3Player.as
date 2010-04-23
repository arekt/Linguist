package {

import flash.display.Sprite;
import bridge.FABridge;

    public class Mp3Player extends Sprite {
        private var externalBridge:FABridge;
        public var fplayer:FABPlayer = new FABPlayer();
        //constructor
        public function Mp3Player(){
            super(); //Sprite
            externalBridge = new FABridge();
            externalBridge.rootObject = this;
        }
    }
}
