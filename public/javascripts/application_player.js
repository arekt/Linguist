$(document).ready(function () {
            $('#mp3_player').flash({   // test_flashvars.swf is the flash document   
                swf: '/Mp3Player.swf',   // these arguments will be passed into the flash document   
                flashvars: { bridgeName: 'mp3_player'   }, 
                width: $('#mp3_player').parent().width(),
                height: 1,
                wmode: "transparent"
            });
            FABridge.addInitializationCallback( "mp3_player", initWaveform );
});

var flashApp;  
var mp3player;

var initWaveform = function() {
    flashApp = FABridge.mp3_player.root();
    mp3player = flashApp.get('fplayer');
    return
    };

function play(audio_filename,start,end){
  if (arguments.length == 3) {
    var duration = end - start;
    mp3player.playMP3(audio_filename,start,duration,'Playing');
  }
  else {
    mp3player.playMP3(audio_filename,0,0,'Playing');
  }
}


