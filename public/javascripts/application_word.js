//This javascript is used by word and sentence show view.

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

function show(url){
  var extract_and_run = function(data){ 
    if ($('#sound').is(':checked'))
      {
        // this is quite fun:
        // extract function connected to link and run this function 
        // this is the same as you click the link
        // so we automaticly play the audio after loading new word
        var play_function = $('h1 a').attr("onclick"); 
        play_function();
      }
  };
 $.get(url,null,extract_and_run,"script");
 return false;
}

function show_next(){
  for (var i=1 in WORDS){
    if (WORDS[i-1] == CURRENT_WORD) 
      {
        CURRENT_WORD = WORDS[i];
        show('/words/'+CURRENT_WORD);
        return false;
      }
  }
}

function show_previous(){
  for (var i=1 in WORDS){
    if (WORDS[i] == CURRENT_WORD) 
      {
        CURRENT_WORD = WORDS[i-1];
        show('/words/'+CURRENT_WORD);
        return false;
      }
  }
}


