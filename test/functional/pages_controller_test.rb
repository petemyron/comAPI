require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get help" do
    get :help
    assert_response :success
  end

end
