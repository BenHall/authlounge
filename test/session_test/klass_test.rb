require File.dirname(__FILE__) + '/../test_helper.rb'

module SessionTest
  module KlassTest
    class ConfigTest < ActiveSupport::TestCase
      def test_authenticate_with
        UserSession.authenticate_with = Employee
        assert_equal "Employee", UserSession.klass_name
        assert_equal Employee, UserSession.klass
    
        UserSession.authenticate_with User
        assert_equal "User", UserSession.klass_name
        assert_equal User, UserSession.klass
      end
    
      def test_klass
        assert_equal User, UserSession.klass
      end

      def test_klass_name
        assert_equal "User", UserSession.klass_name
      end
    end
    
    class InstanceMethodsTest < ActiveSupport::TestCase
      def setup
        reset_users
      end
      def test_record_method
        ben = users(:ben)
        set_session_for(ben)
        session = UserSession.find
        assert_equal ben.id, session.record.id
        assert_equal ben.id, session.user.id
      end
    end
  end
end