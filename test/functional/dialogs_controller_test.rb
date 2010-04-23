require 'test_helper'

class DialogsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Dialog.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Dialog.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Dialog.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to dialog_url(assigns(:dialog))
  end
  
  def test_edit
    get :edit, :id => Dialog.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Dialog.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Dialog.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Dialog.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Dialog.first
    assert_redirected_to dialog_url(assigns(:dialog))
  end
  
  def test_destroy
    dialog = Dialog.first
    delete :destroy, :id => dialog
    assert_redirected_to dialogs_url
    assert !Dialog.exists?(dialog.id)
  end
end
