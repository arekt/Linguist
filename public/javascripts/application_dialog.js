$().ready(function(){

$("ul#dsentences").sortable({placeholder: 'ui-state-highlight', connectWith: 'ul'});

});

function insert_dsentence(html_data){
  $('ul#dsentences').append(html_data);
}

function remove_dsentence(remove_button){ 
  $(remove_button).closest("li").remove();
}

