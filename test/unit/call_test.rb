require 'test_helper'

class CallTest < ActiveSupport::TestCase
  
  test "should create new group from new_group_name" do
    call = Call.new(:method_name => "something", :endpoint_uri => "somewhere", :new_group_name => "new_group")
    assert_difference('Group.count') do
      call.save
    end
  end
end
