class WordsController < ApplicationController

  def index
    @words = Source.first(:section => 'Kotoba').words.all
  end
  
  def show
    @words_ids_json = Source.first(:section => 'Kotoba').words.all.map(&:id).map(&:to_s).to_json
    
    @word = Word.find(params[:id])
    @fragment, @audio = @word.fragment_audio
  
    respond_to do |format|
      format.html # index.html.erb
      format.js  
    end
  end
  
  def new
    @word = Word.new
  end
  
  def create
    @word = Word.new(params[:word])
    if @word.save
      flash[:notice] = "Successfully created word."
      redirect_to @word
    else
      render :action => 'new'
    end
  end
  
  def edit
    @word = Word.find(params[:id])
  end
  
  def update
    @word = Word.find(params[:id])
    if @word.update_attributes(params[:word])
      flash[:notice] = "Successfully updated word."
      redirect_to @word
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @word = Word.find(params[:id])
    @word.destroy
    flash[:notice] = "Successfully destroyed word."
    redirect_to words_url
  end

before_filter :check_for_session_data

protected

  def check_for_session_data
    return if session[:source_conditions] && session[:word_conditions]
    session[:word_conditions] = {}
    session[:source_conditions] = {}
  end

end


