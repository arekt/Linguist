require 'test_helper'

class AdjectivesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Adjective.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Adjective.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Adjective.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to adjective_url(assigns(:adjective))
  end
  
  def test_edit
    get :edit, :id => Adjective.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Adjective.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Adjective.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Adjective.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Adjective.first
    assert_redirected_to adjective_url(assigns(:adjective))
  end
  
  def test_destroy
    adjective = Adjective.first
    delete :destroy, :id => adjective
    assert_redirected_to adjectives_url
    assert !Adjective.exists?(adjective.id)
  end
end
