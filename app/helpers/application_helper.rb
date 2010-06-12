# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current_unit
    session[:unit_id] || Unit.first
  end

      
  def render_embedded(document_or_documents)
    if document_or_documents.class == Array
      class_name = document_or_documents[0].class.to_s.downcase || nil
      form_html = render :partial=>class_name, :collection => document_or_documents unless class_name.nil?
      "<div class=\"#{class_name}\"> #{form_html} </div>" unless class_name.nil?
    else
      class_name = document_or_documents.class.to_s.downcase
      form_html = render :partial=>class_name
      "<div class=\"#{class_name}\"> #{form_html} </div>"
    end   
  end

end
