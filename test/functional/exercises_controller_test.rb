require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Exercise.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Exercise.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Exercise.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to exercise_url(assigns(:exercise))
  end
  
  def test_edit
    get :edit, :id => Exercise.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Exercise.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Exercise.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Exercise.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Exercise.first
    assert_redirected_to exercise_url(assigns(:exercise))
  end
  
  def test_destroy
    exercise = Exercise.first
    delete :destroy, :id => exercise
    assert_redirected_to exercises_url
    assert !Exercise.exists?(exercise.id)
  end
end
