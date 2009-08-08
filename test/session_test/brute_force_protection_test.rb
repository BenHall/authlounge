require File.dirname(__FILE__) + '/../test_helper.rb'

module SessionTest
  module BruteForceProtectionTest
    class ConfigTest < ActiveSupport::TestCase
      setup do
        reset_users
        reset_employees
      end
      
      def test_consecutive_failed_logins_limit
        UserSession.consecutive_failed_logins_limit = 10
        assert_equal 10, UserSession.consecutive_failed_logins_limit
    
        UserSession.consecutive_failed_logins_limit 50
        assert_equal 50, UserSession.consecutive_failed_logins_limit
      end
      
      def test_failed_login_ban_for
        UserSession.failed_login_ban_for = 10
        assert_equal 10, UserSession.failed_login_ban_for
    
        UserSession.failed_login_ban_for 2.hours
        assert_equal 2.hours.to_i, UserSession.failed_login_ban_for
      end
    end
    
    class InstaceMethodsTest < ActiveSupport::TestCase

      def setup
        reset_users
      end
      
      def test_under_limit
        ben = users(:ben)
        ben.failed_login_count = UserSession.consecutive_failed_logins_limit - 1
        assert ben.save
        assert UserSession.create(:login => ben.login, :password => "benrocks")
      end

      def test_exceeded_limit
        ben = users(:ben)
        ben.failed_login_count = UserSession.consecutive_failed_logins_limit
        assert ben.save
        assert UserSession.create(:login => ben.login, :password => "benrocks").new_session?
        ben = User.get(ben.id)
        assert UserSession.create(ben).new_session?
        ben['updated_at'] = (UserSession.failed_login_ban_for + 2.hours.to_i).seconds.ago
        assert !UserSession.create(ben).new_session?
      end
    
      def test_exceeding_failed_logins_limit
        UserSession.consecutive_failed_logins_limit = 2
        ben = users(:ben)
      
        2.times do |i|
          session = UserSession.new(:login => ben.login, :password => "badpassword1")
          assert !session.save
          assert session.errors[:password].size > 0
          assert_equal i + 1, User.get(ben.id).failed_login_count
        end
        
        session = UserSession.new(:login => ben.login, :password => "badpassword2")
        assert !session.save
        assert session.errors[:password].size == 0
        assert_equal 3, User.get(ben.id).failed_login_count
      
        UserSession.consecutive_failed_logins_limit = 50
      end
      
      def test_exceeded_ban_for
        UserSession.consecutive_failed_logins_limit = 2
        UserSession.generalize_credentials_error_messages true
        ben = users(:ben)
      
        2.times do |i|
          session = UserSession.new(:login => ben.login, :password => "badpassword1")
          assert !session.save
          assert session.invalid_password?
          assert_equal i + 1, User.get(ben.id).failed_login_count
        end
        
        
        u = User.get(ben.id)
        u['updated_at'] = 1.day.ago.utc
        u.save_without_callbacks

        session = UserSession.new(:login => ben.login, :password => "benrocks")
        assert session.save
        assert_equal 0, User.get(ben.id).failed_login_count
      
        UserSession.consecutive_failed_logins_limit = 50
        UserSession.generalize_credentials_error_messages false
      end

      def test_exceeded_ban_and_failed_doesnt_ban_again
        UserSession.consecutive_failed_logins_limit = 2
        ben = users(:ben)
      
        2.times do |i|
          session = UserSession.new(:login => ben.login, :password => "badpassword1")
          assert !session.save
          assert session.errors[:password].size > 0
          assert_equal i + 1, User.get(ben.id).failed_login_count
        end

        u = User.get(ben.id)
        u['updated_at'] = 1.day.ago.utc
        u.save_without_callbacks
        
        session = UserSession.new(:login => ben.login, :password => "badpassword1")
        assert !session.save
        assert_equal 1, User.get(ben.id).failed_login_count
      
        UserSession.consecutive_failed_logins_limit = 50
      end
    end
  end
end