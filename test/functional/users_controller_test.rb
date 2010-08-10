require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
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
      # @user.username = "NewUser"
      # @user.email = "newuser@example.com"
      # @user.password = "123456"
      # @user.password_confirmation = "123456"
      # @user.persistence_token = "persistencetoken"
      # puts "@user.attributes=#{@user.attributes.inspect}"
      user_params = {"username"=>"truck", "email"=>"newuser@example.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}
      result = post :create, :user => user_params #@user.attributes
      # puts "@user= #{@user.inspect}"
      puts "\n\n***** " + result.inspect #response.inspect
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end
end
