$(document).ready(function () {
            $('#fragment_player').flash({   // test_flashvars.swf is the flash document   
                swf: '/FragmentPlayer.swf',   // these arguments will be passed into the flash document   
                flashvars: { bridgeName: 'wform'   }, 
                //width: $('#fragment_player').parent().width(),
                width: 800,
                height: 0,
                wmode: "transparent"
            });
            FABridge.addInitializationCallback( "wform", initWaveform );
});
var waveformApp;  

var initWaveform = function() {
    waveformApp = FABridge.wform.root();
    waveformApp.getRoot().addEventListener("change", callback);
    waveformApp.load('/assets/4bd9528137a31c7a6000000c.mp3');
    return
    };

var callback = function(event) {
  alert('something was changed');
}
