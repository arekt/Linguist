class DialogsController < ApplicationController
  def index
    @dialogs = Dialog.all(:order => "created_at")
  end
  
  def show
    @dialog = Dialog.find(params[:id])
  end
  
  def new
    @dialog = Dialog.new
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
