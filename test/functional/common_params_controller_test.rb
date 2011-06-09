require 'test_helper'

class CommonParamsControllerTest < ActionController::TestCase
  setup do
    @common_param = common_params(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:common_params)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create common_param" do
    assert_difference('CommonParam.count') do
      post :create, :common_param => @common_param.attributes
    end

    assert_redirected_to common_param_path(assigns(:common_param))
  end

  test "should show common_param" do
    get :show, :id => @common_param.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @common_param.to_param
    assert_response :success
  end

  test "should update common_param" do
    put :update, :id => @common_param.to_param, :common_param => @common_param.attributes
    assert_redirected_to common_param_path(assigns(:common_param))
  end

  test "should destroy common_param" do
    assert_difference('CommonParam.count', -1) do
      delete :destroy, :id => @common_param.to_param
    end

    assert_redirected_to common_params_path
  end
end
