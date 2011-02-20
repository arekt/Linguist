Keyboard = {
        setup:function(){
                $(document).bind('keydown', 'shift+c', Keyboard.HelloWorld);
                $(document).bind('keydown', 't', Keyboard.showHideTranslation);
        },
        HelloWorld:function(){
                alert("HelloWorld!!!");
        },
        showHideTranslation:function(){
                $("div.translation").toggle('hidden');
        }
        
}

$(function() {
        Keyboard.setup();
});
