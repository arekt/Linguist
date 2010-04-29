$(document).ready(function () {
            $('#fragment_player').flash({   // test_flashvars.swf is the flash document   
                swf: '/FragmentPlayer.swf',   // these arguments will be passed into the flash document   
                flashvars: { bridgeName: 'wform'   }, 
                width: $('#fragment_player').parent().width(),
                salign: "t",
                //scale: "exactfit",
                wmode: "transparent"
            });
            FABridge.addInitializationCallback( "wform", initWaveform );
});
var waveformApp;  

var initWaveform = function() {
    waveformApp = FABridge.wform.root();
    waveformApp.getRoot().addEventListener("SELECTION_CHANGED", callback);
    waveformApp.load(audio_url);
    return
    };

var callback = function(event) {
  //alert('something was changed');
}
