require 'test_helper'

class FragmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fragments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fragment" do
    assert_difference('Fragment.count') do
      post :create, :fragment => { }
    end

    assert_redirected_to fragment_path(assigns(:fragment))
  end

  test "should show fragment" do
    get :show, :id => fragments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => fragments(:one).to_param
    assert_response :success
  end

  test "should update fragment" do
    put :update, :id => fragments(:one).to_param, :fragment => { }
    assert_redirected_to fragment_path(assigns(:fragment))
  end

  test "should destroy fragment" do
    assert_difference('Fragment.count', -1) do
      delete :destroy, :id => fragments(:one).to_param
    end

    assert_redirected_to fragments_path
  end
end
