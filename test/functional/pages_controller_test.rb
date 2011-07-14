require 'test_helper'

class PagesControllerTest < ActionController::TestCase
    
  # Devise helpers
  include Devise::TestHelpers


  setup do
#     @user = users(:one)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get help" do
    get :help
    assert_response :success
  end

end
