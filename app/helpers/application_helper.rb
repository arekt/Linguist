# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current_unit
    session[:unit_id] || Unit.first
  end
end
