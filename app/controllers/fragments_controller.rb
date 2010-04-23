class FragmentsController < ApplicationController
  # GET /fragments
  # GET /fragments.xml
  def index
    @audio = Audio.find(params[:audio_id])
    @fragments = @audio.fragments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fragments }
    end
  end

  # GET /fragments/1
  # GET /fragments/1.xml
  def show
    @audio = Audio.find(params[:audio_id])
    @fragment = @audio.fragments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fragment }
    end
  end

  # GET /fragments/new
  # GET /fragments/new.xml
  def new
    @audio = Audio.find(params[:audio_id])
    @fragment = Fragment.new
    respond_to do |format|
      format.html # new.html.erb
      format.js 
    end
  end

  # GET /fragments/1/edit
  def edit
    @audio = Audio.find(params[:audio_id])
    @fragment = @audio.fragments.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  # POST /fragments
  # POST /fragments.xml
  def create
    @audio = Audio.find(params[:audio_id])
    @fragment = Fragment.new(params[:fragment])
    @audio.fragments << @fragment
    @fragments = @audio.fragments

    respond_to do |format|
      if @fragment.save
        format.html { redirect_to audio_fragment_url(@audio,@fragment) }
        format.js  
      else
        format.html { render :action => "new" }
        format.js   { render :inline => 'alert("Something went wrong.");' };
      end
    end
  end

  # PUT /fragments/1
  # PUT /fragments/1.xml
  def update
    @audio = Audio.find(params[:audio_id])
    @fragment = @audio.fragments.find(params[:id])

    respond_to do |format|
      if @fragment.update_attributes(params[:fragment])
        @fragments = @audio.fragments
        format.html { redirect_to audio_fragment_path(@audio,@fragment) }
        format.js   
      else
        format.html { render :action => "edit" }
        format.js   { render :inline => 'alert("Something went wrong.");' };
      end
    end
  end

  # DELETE /fragments/1
  # DELETE /fragments/1.xml
  def destroy
    @audio = Audio.find(params[:audio_id])
    @fragment = @audio.fragments.find(params[:id])
    @audio.fragments.delete(@fragment)
  
    respond_to do |format|
      if @audio.save
        format.html { redirect_to audio_fragments_url(@audio) }
      else
        flash[:error] = 'I can\'t delete this item.'
        format.html { redirect_to audio_fragments_url(@audio) }
      end
    end
  end
end
