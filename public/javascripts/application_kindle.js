Keyboard = {
        setup:function(){
                $(document).bind('keydown', 'shift+c', Keyboard.HelloWorld);
                $(document).bind('keydown', 't', Keyboard.showHideTranslation);
                $(document).bind('keydown', 's', Keyboard.goToSentences);
                $(document).bind('keydown', 'w', Keyboard.goToWords);
                $(document).bind('keydown', 'u', Keyboard.goToUnits);
            
        },
        HelloWorld:function(){
                alert("HelloWorld!!!");
        },
        showHideTranslation:function(){
                $("div.translation").toggle('hidden');
        },
        goToSentences:function(){
          if($('a.sentences').length){
            window.location = $('a.sentences').attr('href');
          }
        },
        goToWords:function(){
          if($('a.words').length){
            window.location = $('a.words').attr('href');
          }
        },
        goToUnits:function(){
          if($('a.units').length){
            window.location = $('a.units').attr('href');
          }
        }
}

$(function() {
        Keyboard.setup();
});
