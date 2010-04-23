function insert_translation(html_data){ 
  $('div.translations').append(html_data);
}

function insert_dsentence(html_data){
  $('table#dsentences').append(html_data);
}

function insert_question(html_data){
  $('div#questions').append(html_data);
}

function remove_translation(remove_button){ 
  //alert('removing'+$(remove_button).closest(".single_translation").html());
  $(remove_button).closest(".single_translation").remove();
}

function remove_dsentence(remove_button){ 
  //alert('removing'+$(remove_button).closest("tr").html());
  $(remove_button).closest("tr").remove();
}

function remove_question(remove_button){ 
  //alert('removing'+$(remove_button).closest("tr").html());
  $(remove_button).closest(".single_question").remove();
}

function show_example_and_change_link(tag_id,ex_html,link){
  $(link).hide();
  $(tag_id).html(ex_html);
}
