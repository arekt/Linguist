require File.dirname(__FILE__) + '/../spec_helper'
 
describe KnowledgeTestsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => KnowledgeTest.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    KnowledgeTest.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    KnowledgeTest.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(knowledge_test_url(assigns[:knowledge_test]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => KnowledgeTest.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    KnowledgeTest.any_instance.stubs(:valid?).returns(false)
    put :update, :id => KnowledgeTest.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    KnowledgeTest.any_instance.stubs(:valid?).returns(true)
    put :update, :id => KnowledgeTest.first
    response.should redirect_to(knowledge_test_url(assigns[:knowledge_test]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    knowledge_test = KnowledgeTest.first
    delete :destroy, :id => knowledge_test
    response.should redirect_to(knowledge_tests_url)
    KnowledgeTest.exists?(knowledge_test.id).should be_false
  end
end
