ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'turn'

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  setup :log_test
  
  # Add more helper methods to be used by all tests here...

  private
  
  def log_test
    if Rails::logger
      # When I run tests in rake or autotest I see the same log message multiple times per test for some reason.
      # This guard prevents that.
      unless @already_logged_this_test
        Rails::logger.info "\n\nStarting #{@method_name}\n#{'-' * (9 + @method_name.length)}\n"
      end
      @already_logged_this_test = true
    end
  end

end
