require 'test_helper'

class FollowingsControllerTest < ActionController::TestCase
  setup do
    @following = followings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:followings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create following" do
    assert_difference('Following.count') do
      post :create, following: { email: @following.email, first_name: @following.first_name, user_name: @following.user_name }
    end

    assert_redirected_to following_path(assigns(:following))
  end

  test "should show following" do
    get :show, id: @following
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @following
    assert_response :success
  end

  test "should update following" do
    patch :update, id: @following, following: { email: @following.email, first_name: @following.first_name, user_name: @following.user_name }
    assert_redirected_to following_path(assigns(:following))
  end

  test "should destroy following" do
    assert_difference('Following.count', -1) do
      delete :destroy, id: @following
    end

    assert_redirected_to followings_path
  end
end
