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

  # GET /audios/1
  # GET /audios/1.xml
  def show
    @audio = Audio.find(params[:id])
    @fragments = @audio.fragments
    if (@audio.waveform.nil?||@audio.waveform.empty?) then
      generate_waveform(@audio)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @audio }
      format.text { redirect_to "/waveform/"+@audio.id.to_s }
    end
  end

  # GET /audios/new
  # GET /audios/new.xml
  def new
    @audio = Audio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @audio }
    end
  end

  # GET /audios/1/edit
  def edit
    @audio = Audio.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  # POST /audios
  # POST /audios.xml
  def create
    uploaded_io = params[:audio][:file] 
    @audio = Audio.new(:filename => uploaded_io.original_filename)
    @audio.source_id = params[:audio][:source_id]
    File.open(Rails.root.join('public','uploads',uploaded_io.original_filename), 'w') do |file|
      file.write(uploaded_io.read)
    end
    respond_to do |format|
      if @audio.save
        flash[:notice] = 'Audio was successfully created.'
        format.html { redirect_to(@audio) }
        format.xml  { render :xml => @audio, :status => :created, :location => @audio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @audio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /audios/1
  # PUT /audios/1.xml
  def update
    @audio = Audio.find(params[:id])
    respond_to do |format|
      if @audio.update_attributes(params[:audio])
        flash[:notice] = 'Audio was successfully updated.'
        format.html { redirect_to(@audio) }
        format.js      
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  # DELETE /audios/1
  # DELETE /audios/1.xml
  def destroy
    @audio = Audio.find(params[:id])
    @audio.destroy

    respond_to do |format|
      format.html { redirect_to(audios_url) }
      format.xml  { head :ok }
    end
  end
  private
  def generate_waveform(audio)
    Waveform.send :new, audio.filename, audio.id.to_s
    audio.waveform = audio.id.to_s
    audio.save
  end

end
