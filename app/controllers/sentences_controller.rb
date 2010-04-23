class SentencesController < ApplicationController
  
  def index
   if params[:search]
      re_unit = /\s*unit:(\d+)\s*/
      re_section = /\s*section:(\w+)\s*/
      source_unit = re_unit.match(params[:search])
      source_section = re_section.match(params[:search])
      session[:source_conditions]={}
      session[:source_conditions][:unit] = source_unit[1] if source_unit
      session[:source_conditions][:section] = source_section[1] if source_section
      sentence_conditions = params[:search].gsub(re_unit,'').gsub(re_section,'')
   end
   logger.debug "*** conditions : #{sentence_conditions.inspect}"
   if sentence_conditions 
     session[:sentence_conditions] = { :content => Regexp.new(sentence_conditions) }
   else
     session[:sentence_conditions]={}
   end
    
    logger.debug "session data: #{session.inspect}"
      
    @sentences = Source.all(:conditions => session[:source_conditions]).map do |s| 
      s.sentences.all(:conditions => session[:sentence_conditions])
    end.flatten
    @search = SearchResult.first(:user_id => current_user().id, :search_type => :sentences) || SearchResult.new(:user_id => current_user().id)
    @search.result = @sentences.map(&:id)
    @search.search_type = :sentences
    @search.save
  end
  
  def show
    @sentence = Sentence.find(params[:id])
    @next = @sentence.next(current_user)
    @previous = @sentence.previous(current_user)
    @fragment, @audio = @sentence.fragment_audio
  end
  
  def new
    @sentence = Sentence.new
    @sentence.source_id = session['default_source'] if session['default_source'] 
    @translations=@sentence.translations
    @translations << Translation.new
  end
  
  def create
    @sentence = Sentence.new(params[:sentence])
    session['default_source'] = params[:sentence][:source_id] if params[:sentence][:source_id]
    if @sentence.save
      flash[:notice] = "Successfully created sentence."
      redirect_to @sentence
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sentence = Sentence.find(params[:id])
    @translations = @sentence.translations 
    @translations << Translation.new
    logger.debug "*** translations : #{@translations}"
  end
  
  def update
    @sentence = Sentence.find(params[:id])
    if @sentence.update_attributes(params[:sentence])
      flash[:notice] = "Successfully updated sentence."
      redirect_to @sentence
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sentence = Sentence.find(params[:id])
    @sentence.destroy
    flash[:notice] = "Successfully destroyed sentence."
    redirect_to sentences_url
  end
end
