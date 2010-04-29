class AudiosController < ApplicationController
  # GET /audios
  # GET /audios.xml
  def index
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @audios = @unit.assets(:file_type => "audio/mpeg")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @audios }
    end
  end
end
