class AdjectivesController < ApplicationController
  def index
    @adjectives = Adjective.all
  end
  
  def show
    @adjective = Adjective.find(params[:id])
  end
  
  def new
    @adjective = Adjective.new
  #  @adjective.translations << Translation.new
  end
  
  def create
    @adjective = Adjective.new(params[:adjective])
    if @adjective.save
      flash[:notice] = "Successfully created adjective."
      redirect_to @adjective
    else
      render :action => 'new'
    end
  end
  
  def edit
    @adjective = Adjective.find(params[:id])
  #  @adjective.translations << Translation.new 
  end
  
  def update
    @adjective = Adjective.find(params[:id])
    if @adjective.update_attributes(params[:adjective])
      flash[:notice] = "Successfully updated adjective."
      redirect_to @adjective
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @adjective = Adjective.find(params[:id])
    @adjective.destroy
    flash[:notice] = "Successfully destroyed adjective."
    redirect_to adjectives_url
  end
end
