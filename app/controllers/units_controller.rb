class UnitsController < ApplicationController
  def index
    @units = Unit.all
  end
  
  def show
    @unit = Unit.find(params[:id])
  end
  
  def new
    @unit = Unit.new
  end
  
  def create
    @unit = Unit.new(params[:unit])
    logger.debug "#### params: #{params[:unit].inspect}"
    @unit.assets << Asset.new(params[:asset])
    if @unit.save
      flash[:notice] = "Successfully created unit."
      redirect_to @unit
    else
      render :action => 'new'
    end
  end
  
  def edit
    @unit = Unit.find(params[:id])
  end
  
  def update
    @unit = Unit.find(params[:id])
    @unit.assets << Asset.new(params[:asset])
    if @unit.update_attributes(params[:unit])
      flash[:notice] = "Successfully updated unit."
      redirect_to @unit
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy
    flash[:notice] = "Successfully destroyed unit."
    redirect_to units_url
  end

  def current
   session[:unit_id] = params[:unit][:id]
   @unit = Unit.find(params[:unit][:id])
  end

end
