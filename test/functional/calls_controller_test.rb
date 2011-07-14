require 'test_helper'

class CallsControllerTest < ActionController::TestCase
    
  # Devise helpers
  include Devise::TestHelpers

  setup do
    @call = calls(:one)
    
    @update = {
      :method_name => 'MyString3',
      :endpoint_uri => 'MyString3',
      :group_id => 1,
      :xml => 'MyText3',
      :method_type => 'POST'
    }
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
#    assert_not_nil assigns(:calls)
    assert_not_nil assigns(:list)
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
    call = Call.new(:method_name => "something", :group_id => 1, :endpoint_uri => "somewhere")
    call.build_group(:name => "group_name")
    call.save
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
  
  test "can sign_in" do
    assert(sign_in @user)
  end
  
  test "should log the call if signed in" do
    sign_in @user
    call = Call.new(:method_name => "something", :group_id => 1, :endpoint_uri => "somewhere", :xml => "xml")
    call.save
    assert_difference('Log.count') do
      get :make_request, :id => call.to_param
    end
  end
  
  test "should not log the call if not signed in" do
    sign_out @user
    call = Call.new(:method_name => "something", :group_id => 1, :endpoint_uri => "somewhere", :xml => "xml")
    call.save
    assert_no_difference('Log.count') do
      get :make_request, :id => call.to_param
    end
  end
  
  test "should create new group from new call" do
    call = Call.new(:method_name => "something", :new_group_name => "new_group", :endpoint_uri => "somewhere")
    assert_difference('Group.count') do
      post :create, :call => call
    end
    assert_redirected_to call_path(assigns(:call))
  end


##  Test recent_group_id
  test "should show recent group if signed in and recent_group_id set" do
    sign_in @user
    group = @user.recent_group_id
    get :index
    assert_tag(:tag => 'li', :content => '#{group}',:attributes => {:class => 'active_tab'})
    sign_out @user
  end
  
  test "should show All tab if signed in and recent_group_id NOT set" do
    sign_in users(:two)
    # recent_group_id should not be assigned for user :two in the fixture
    get :index
    assert_tag(:tag => 'li', :content => 'All',:attributes => {:class => 'active_tab'})
    sign_out users(:two)
  end
  
  test "should show the All tab if user not signed in" do
    get :index
    assert_tag(:tag => 'li', :content => 'All',:attributes => {:class => 'active_tab'})
  end

end

















