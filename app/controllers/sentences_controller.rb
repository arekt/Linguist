class SentencesController < ApplicationController
  
  def index
      @unit = Unit.find(session[:unit_id]) || Unit.first
      @sentences = @unit.sentences.all

  end
  
  def show
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @sentences_ids_json = @unit.sentences.all.map(&:id).map(&:to_s).to_json
    @sentence = Sentence.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.js  
    end
  end
  
  def new
    @sentence = Sentence.new  
  end
  
  def create
    @sentence = Sentence.new(params[:sentence])
    if @sentence.save
      flash[:notice] = "Successfully created sentence."
      redirect_to @sentence
    else
      render :action => 'new'
    end
  end
  
  def edit
      @sentence = Sentence.find(params[:id])
      @asset = Asset.find(params[:asset_id])
      @sentence.fragment.asset = @asset
     
      respond_to do |format|
        format.html
        format.js
     end
  end
  
  def update
    @sentence = Sentence.find(params[:id])
    @asset = Asset.find(params[:asset_id])

    respond_to do |format|
        if @sentence.update_attributes(params[:sentence])
          flash[:notice] = "Successfully updated sentence."
          format.html{redirect_to @sentence}
          format.js
        else
          format.html{render :action => 'edit'}
        end
    end
  end
  
  def destroy
    @sentence = Sentence.find(params[:id])
    @sentence.destroy
    flash[:notice] = "Successfully destroyed sentence."
    redirect_to sentences_url
  end
end
