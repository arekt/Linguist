class WordsController < ApplicationController

  def index
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @words = @unit.words.all
  end
  
  def show
    @word = Word.find(params[:id])
    @unit = @word.unit
    @words_ids_json = @unit.words.all.map(&:id).map(&:to_s).to_json
    respond_to do |format|
      format.html # index.html.erb
      format.js  
    end
  end
  
  def new
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @word = Word.new
    @word.unit = @unit
    @asset = Asset.find(params[:asset_id])
    @word.fragment = Fragment.new
    @word.fragment.asset = @asset
    logger.debug "***new word #{@word.inspect}"
     respond_to do |format|
      format.html
      format.js
    end
 end
  
  def create
    @word = Word.new(params[:word])
    logger.debug "*** create word #{@word.inspect}"
    @asset = Asset.find(params[:asset_id])
    respond_to do |format|
      if @word.save
        flash[:notice] = "Successfully created word."
        format.html{redirect_to @word}
        format.js
      else
        format.html{render :action => 'new'}
      end
    end
  end
  
  def edit
    @word = Word.find(params[:id])
    @asset = Asset.find(params[:asset_id])
    @word.fragment.asset = @asset
    @unit = @word.unit
     
    respond_to do |format|
      format.html
      format.js
    end
end
  
  def update
    @word = Word.find(params[:id])
    @asset = Asset.find(params[:asset_id])
    
    respond_to do |format|
        if @word.update_attributes(params[:word])
          flash[:notice] = "Successfully updated word."
          format.html{redirect_to @word}
          format.js
        else
          format.html{render :action => 'edit'}
        end
    end
  end
  
  def destroy
    @word = Word.find(params[:id])
    @word.destroy
    flash[:notice] = "Successfully destroyed word."
    redirect_to words_url
  end
end


