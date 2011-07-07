require 'test_helper'

class PagesControllerTest < ActionController::TestCase
    
  # Devise helpers
  include Devise::TestHelpers

  test "should get help" do
    get :help
    assert_response :success
  end

end
