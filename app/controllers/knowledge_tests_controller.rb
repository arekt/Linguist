class KnowledgeTestsController < ApplicationController
  def index
    @knowledge_tests = KnowledgeTest.all
  end
  
  def show
    @knowledge_test = KnowledgeTest.find(params[:id])
  end
  
  def new
    @knowledge_test = KnowledgeTest.new
  end
  
  def create
    @knowledge_test = KnowledgeTest.new(params[:knowledge_test])
    if @knowledge_test.save
      flash[:notice] = "Successfully created knowledge test."
      redirect_to @knowledge_test
    else
      render :action => 'new'
    end
  end
  
  def edit
    @knowledge_test = KnowledgeTest.find(params[:id])
  end
  
  def update
    @knowledge_test = KnowledgeTest.find(params[:id])
    if @knowledge_test.update_attributes(params[:knowledge_test])
      flash[:notice] = "Successfully updated knowledge test."
      redirect_to @knowledge_test
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @knowledge_test = KnowledgeTest.find(params[:id])
    @knowledge_test.destroy
    flash[:notice] = "Successfully destroyed knowledge test."
    redirect_to knowledge_tests_url
  end
end
