$(document).ready(function () {
            $('#fragment_player').flash({   // test_flashvars.swf is the flash document   
                swf: '/FragmentPlayer.swf',   // these arguments will be passed into the flash document   
                flashvars: { bridgeName: 'wform'   }, 
                width: $('#fragment_player').parent().width(),
                height: $('#fragment_player').parent().width()*115/1024,
                salign: "t",
                //scale: "exactfit",
                wmode: "transparent"
                // for more options look here: http://kb2.adobe.com/cps/127/tn_12701.html
            });
            FABridge.addInitializationCallback( "wform", initWaveform );

            $("#updateForm>form").live('submit',function(){
              $.post($(this).attr('action'), $(this).serialize(), null, "script");
              alert($(this).serialize());
            return false;
            });

});
var waveformApp;  

var initWaveform = function() {
    waveformApp = FABridge.wform.root();
    waveformApp.set("y",-27);  //could someone tell we why I need do this ?? probably there is a bug in swfobject
    waveformApp.getRoot().addEventListener("SELECTION_CHANGED", callback);
    waveformApp.load(audio_url);
    $('#fragment_player').children('#loading').html('');
    return
    };

var callback = function(event) {
  //alert(waveformApp.get("sStart")+":"+waveformApp.get("sEnd"));
  start = waveformApp.getSelectionTimes()[0];
  stop = waveformApp.getSelectionTimes()[1];
  $("form input#word_fragment_start").val(start);
  $("form input#word_fragment_stop").val(stop);
  $("form input#sentence_fragment_start").val(start);
  $("form input#sentence_fragment_stop").val(stop);

}

var addWord = function(word_id) {
  if (word_id != null) {
  $.get("/assets/"+asset_id+"/words/"+word_id+"/edit", null, null, "script"); }
  else {
  $.get("/assets/"+asset_id+"/words/new", null, null, "script");
  }
  return false;
}

var addSentence = function(sentence_id) {
  if (sentence_id != null) {
  $.get("/assets/"+asset_id+"/sentences/"+sentence_id+"/edit", null, null, "script");}
  else {
  $.get("/assets/"+asset_id+"/sentences/new", null, null, "script");
  }
  return false;
}

var removeFromAsset = function() {
  var form = $("#updateForm>form");
  $('#asset_id > input').val('');
  form.trigger('submit');
  return false;
}
