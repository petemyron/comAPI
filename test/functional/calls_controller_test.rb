require 'test_helper'

class CallsControllerTest < ActionController::TestCase
    
  # Devise helpers
  include Devise::TestHelpers

  setup do
    @call = calls(:one)
    @user = users(:one)    
    @update = {
      :method_name => 'MyString3',
      :endpoint_uri => 'MyString3',
      :group_id => 1,
      :xml => 'MyText3',
      :method_type => 'POST'
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:calls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call" do
    assert_difference('Call.count') do
      post :create, :call => @update
    end

    assert_redirected_to call_path(assigns(:call))
  end

  test "should show call" do
    call = calls(:one)
    get :show, :id => call.to_param
    
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @call.to_param
    assert_response :success
  end

  test "should update call" do
    put :update, :id => @call.to_param, :call => @call.attributes
    assert_redirected_to call_path(assigns(:call))
  end

  test "should destroy call" do
    assert_difference('Call.count', -1) do
      delete :destroy, :id => @call.to_param
    end

    assert_redirected_to calls_path
  end

end

















