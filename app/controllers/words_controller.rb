class WordsController < ApplicationController

  def index
    @unit = Unit.find(session[:unit_id]) || Unit.first
    
    @search={}
    if params.has_key?(:category) && params[:category].to_s != ""
      @search[:category] = params[:category].to_s
    end
    if params.has_key?(:content) && params[:content] != ""
      @search[:content] = Regexp.new(params[:content])
    end
    if params.has_key?(:asset_id) && params[:asset_id].to_s != ""
      @search['fragment.asset_id'] = BSON::ObjectID.from_string(params[:asset_id].to_s)
    end
    @words = @unit.words.sort("created_at").all(@search)
    session[:search] = @search
  end
  
  def show
    @search = session[:search] || {}
    @word = Word.find(params[:id])
    @unit = @word.unit
    @words_ids_json = @unit.words.sort("created_at").all(@search).map(&:id).map(&:to_s).to_json
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
        format.js { render :update do |page|
          page.replace_html 'updateForm', ""
          page << "waveformApp.set('attachedFragments', #{@asset.fragments.to_json});"
          page << "waveformApp.drawFragments();"
        end
        }
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
          format.js { render :update do |page|
            page.replace_html 'updateForm', ""
            page << "waveformApp.set('attachedFragments', #{@asset.fragments.to_json});"
            page << "waveformApp.drawFragments();"
          end
          }
 
        else
          format.html{render :action => 'edit'}
        end
    end
  end
  
  def destroy
    @word = Word.find(params[:id])
    @word.destroy
    flash[:notice] = "Successfully destroyed word."
    respond_to do |format|
          format.js { render :update do |page|
          page.replace_html 'updateForm', ""
          page << "waveformApp.set('attachedFragments', #{@asset.fragments.to_json});"
          page << "waveformApp.drawFragments();"
        end
        }
          format.html { redirect_to sentences_url }
    end
  end
end


