class DialogsController < ApplicationController
  def index
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @dialogs = @unit.dialogs.all
  end
  
  def show
    @dialog = Dialog.find(params[:id])
    @unit = @dialog.unit
  end
  
  def new
    @dialog = Dialog.new
    @unit = Unit.find(session[:unit_id]) || Unit.first
    @dialog.unit = @unit
    @dsentences = [ Dsentence.new ]
  end
  
  def create
    @dialog = Dialog.new(params[:dialog])
    if @dialog.save
      flash[:notice] = "Successfully created dialog."
      redirect_to @dialog
    else
      render :action => 'new'
    end
  end
  
  def edit
    @dialog = Dialog.find(params[:id])
    @dsentences = @dialog.dsentences
    @unit = @dialog.unit 
  end
  
  def update
    @dialog = Dialog.find(params[:id])
    if @dialog.update_attributes(params[:dialog])
      flash[:notice] = "Successfully updated dialog."
      redirect_to @dialog
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @dialog = Dialog.find(params[:id])
    @dialog.destroy
    flash[:notice] = "Successfully destroyed dialog."
    redirect_to dialogs_url
  end
end
