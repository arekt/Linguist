class WordsController < ApplicationController

  def index
    if params[:search]
      re_unit = /\s*unit:(\d+)\s*/
      word_conditions = params[:search].gsub(re_unit,'')
      session[:source_conditions] = $1?{:unit => $1 }:{}
      if word_conditions.empty?
        session[:word_conditions] = {}
      else
        session[:word_conditions] = { :content => Regexp.new(word_conditions) }
      end
    end
    logger.debug "session data: #{session.inspect}"
      
    @words = Source.all(:conditions => session[:source_conditions],:limit=>100).map {|s| s.words.all(:conditions => session[:word_conditions])}.flatten
    @search = SearchResult.first(:user_id => current_user().id, :search_type => :words) || SearchResult.new(:user_id => current_user().id)
    @search.result = @words.map(&:id)
    @search.search_type = :words
    @search.save
  end
  
  def show
    #@words = SearchResult.first(:user_id => current_user().id).result
    @word = Word.find(params[:id])
    @next = @word.next(current_user)
    @previous = @word.previous(current_user)
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


