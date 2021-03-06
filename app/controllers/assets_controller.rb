class AssetsController < ApplicationController
  def index
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @assets = @unit.assets
  end
  
  def show
    @asset = Asset.find(params[:id])
    @unit = @asset.unit
    respond_to do |format|
      format.html
      format.mp3 do 
        send_data @asset.file.read, :type => @asset.file.content_type, :disposition => 'inline'
      end
    end
  end
  
  def new
    @asset = Asset.new
    @asset.unit = Unit.find(session[:unit_id]) || Unit.first
  end
  
  def create
    @asset = Asset.new(params[:asset])
    
    if @asset.save
      flash[:notice] = "Successfully created asset."
      redirect_to @asset
    else
      render :action => 'new'
    end
  end
  
  def edit
    @asset = Asset.find(params[:id])
    @unit = @asset.unit
  end
  
  def update
    @asset = Asset.find(params[:id])
    if @asset.update_attributes(params[:asset])
      flash[:notice] = "Successfully updated asset."
      redirect_to @asset
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    flash[:notice] = "Successfully destroyed asset."
    redirect_to assets_url
  end

  def fragments
    @asset = Asset.find(params[:asset_id])
    logger.debug "***** asset_id: #{@asset.id} fragments: #{@asset.fragments.inspect}"

    render :update do |page|
      #page.replace_html  'ble', "hello"
      page << "fragments = #{@asset.fragments.to_json};"
      page << "alert(fragments);"
    end
  end
end
