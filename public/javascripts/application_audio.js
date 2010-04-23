$(document).ready(function () {
            $('#mp3_player').flash({   // test_flashvars.swf is the flash document   
                swf: '/WaveformGraph.swf',   // these arguments will be passed into the flash document   
                flashvars: { bridgeName: 'wform'   }, 
                width: $('#mp3_player').parent().width(),
                height: 50,
                wmode: "transparent"
            });
            FABridge.addInitializationCallback( "wform", initWaveform );
            $("form.edit_audio").live('submit',function(){
            $.post($(this).attr('action'), $(this).serialize(), null, "script");
            alert('update');
            return false;
            });
});
var waveformApp;  
var mp3player;

function display_fragment_form(url){
  $.get(url, null, null, "script");
}

function play_fragment(){
  $.get('/play/'+$('#active_fragment #audio_fragment_attributes__sentence_id').val(),null,null,'script');  // go to sentence/play, play fragment, and put start, end time to the form  
}


var initWaveform = function() {
    waveformApp = FABridge.wform.root();
    mp3player = waveformApp.get('fplayer');
    waveformApp.getRoot().addEventListener("change", callback);
    waveformApp.load('/waveform/'+audio_waveform);
    return
    };

var callback = function(event) {
   var stats = waveformApp.getStats();
   selection_start = stats.selection_start_time;
   //$("input#fragment_start").val(stats.selection_start_time);
   $('#active_fragment #fragment_start').val(stats.selection_start_time);
   $('#active_fragment #fragment_end').val(stats.selection_stop_time);
   duration = stats.selection_stop_time-stats.selection_start_time;
   //$("input#fragment_duration").val(stats.selection_stop_time-stats.selection_start_time);
   //alert("selection_start: " + selection_start);
   //waveformApp.load('/waveform/'+audio_waveform);
   mp3player.playMP3('/uploads/'+audio_filename,selection_start,duration,'Playing'); // we setup audio_filename in audio/show.html.erb
}

function play(start,end){
  if (arguments.length == 2) {
    var duration = end - start;
    mp3player.playMP3('/uploads/'+audio_filename,start,duration,'Playing');
  }
  else {
    mp3player.playMP3('/uploads/'+audio_filename,selection_start,duration,'Playing');
  }
}
function waveform_backward(){ 
  waveformApp.backward(); 
}
function waveform_forward(){  
  waveformApp.forward(); 
}


