require 'test_helper'

class SentencesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Sentence.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Sentence.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Sentence.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to sentence_url(assigns(:sentence))
  end
  
  def test_edit
    get :edit, :id => Sentence.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Sentence.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Sentence.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Sentence.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Sentence.first
    assert_redirected_to sentence_url(assigns(:sentence))
  end
  
  def test_destroy
    sentence = Sentence.first
    delete :destroy, :id => sentence
    assert_redirected_to sentences_url
    assert !Sentence.exists?(sentence.id)
  end
end
