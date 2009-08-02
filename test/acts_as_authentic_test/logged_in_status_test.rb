require File.dirname(__FILE__) + '/../test_helper.rb'

module ActsAsAuthenticTest
  class LoggedInStatusTest < ActiveSupport::TestCase
    def test_logged_in_timeout_config
      assert_equal 10.minutes.to_i, User.logged_in_timeout
      assert_equal 10.minutes.to_i, Employee.logged_in_timeout
      
      User.logged_in_timeout = 1.hour
      assert_equal 1.hour.to_i, User.logged_in_timeout
      User.logged_in_timeout 10.minutes
      assert_equal 10.minutes.to_i, User.logged_in_timeout
    end
    
    def test_named_scope_logged_in
      reset_users
      assert_equal 0, User.logged_in.size
      u = User.all()[0]
      u.last_request_at = Time.now
      u.save_without_callbacks
      assert_equal 1, User.logged_in.size
    end
    
    def test_named_scope_logged_out
      reset_users
      assert_equal 2, User.logged_out.size
      u = User.all()[1]
      u.last_request_at = Time.now
      u.save_without_callbacks
      assert_equal 1, User.logged_out.size
    end
    
    def test_logged_in_logged_out
      reset_users
      u = User.all()[0]
      assert !u.logged_in?
      assert u.logged_out?
      u.last_request_at = Time.now
      u.save_without_callbacks
      assert u.logged_in?
      assert !u.logged_out?
    end
  end
end