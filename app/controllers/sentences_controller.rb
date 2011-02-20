class SentencesController < ApplicationController
  
  def index
      @unit = Unit.find(session[:unit_id]) || Unit.first

    @search={:sort => "fragment.start"}
    if params.has_key?(:category) && params[:category].to_s != ""
      @search[:category] = params[:category].to_s
    end
    if params.has_key?(:content) && params[:content] != ""
      @search[:content] = Regexp.new(params[:content])
    end
    if params.has_key?(:asset_id) && params[:asset_id].to_s != ""
      @search['fragment.asset_id'] = BSON::ObjectID.from_string(params[:asset_id].to_s)
    end

      @sentences = @unit.sentences.all(@search)
      session[:search]=@search
  end
  
  def show
    logger.debug "search : #{session[:search].inspect}"
    @search=session[:search] || {}
    @sentence = Sentence.find(params[:id])
    @unit = @sentence.unit
    @sentences_ids_json = @unit.sentences.all(@search).map(&:id).map(&:to_s).to_json
    
    respond_to do |format|
      format.html # index.html.erb
      format.js  
    end
  end
  
  def new
    @sentence = Sentence.new 
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @sentence.unit =  @unit
    @sentence.fragment = Fragment.new
    @asset = Asset.find(params[:asset_id])
    @sentence.fragment.asset = @asset 

    respond_to do |format|
      format.html # index.html.erb
      format.js  
    end
  end
  
  def create
    @sentence = Sentence.new(params[:sentence])
    @asset = Asset.find(params[:asset_id])

    respond_to do |format|
      if @sentence.save
        flash[:notice] = "Successfully created sentence."
        format.html{redirect_to @sentence}
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
      @sentence = Sentence.find(params[:id])
      @asset = Asset.find(params[:asset_id])
      @sentence.fragment.asset = @asset
      @unit = @sentence.unit
     
      respond_to do |format|
        format.html { render :layout => false }
        format.js { render :layout => false }
     end
  end
  
  def update
    @sentence = Sentence.find(params[:id])
    @asset = Asset.find(params[:asset_id])

    respond_to do |format|
        if @sentence.update_attributes(params[:sentence])
          flash[:notice] = "Successfully updated sentence."
          format.html{redirect_to @sentence}
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
    @sentence = Sentence.find(params[:id])
    @sentence.destroy
    flash[:notice] = "Successfully destroyed sentence."
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
