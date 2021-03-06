require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    activate_authlogic
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      user_params = {"username"=>"truck", "email"=>"newuser@example.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}
      result = post :create, :user => user_params #@user.attributes
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    UserSession.create(users(:one))
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    UserSession.create(users(:one))
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    UserSession.create(users(:admin))
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end
end
