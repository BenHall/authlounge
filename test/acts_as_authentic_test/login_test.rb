require File.dirname(__FILE__) + '/../test_helper.rb'

module ActsAsAuthenticTest
  class LoginTest < ActiveSupport::TestCase
    setup do
      reset_users
      reset_employees
    end
    def test_login_field_config
      assert_equal :login, User.login_field
      assert_nil Employee.login_field
      
      User.login_field = :nope
      assert_equal :nope, User.login_field
      User.login_field :login
      assert_equal :login, User.login_field
    end
    
    def test_validate_login_field_config
      assert User.validate_login_field
      assert Employee.validate_login_field
      
      User.validate_login_field = false
      assert !User.validate_login_field
      User.validate_login_field true
      assert User.validate_login_field
    end
    
    def test_validates_length_of_login_field_options_config
      assert_equal({:within => 3..100}, User.validates_length_of_login_field_options)
      assert_equal({:within => 3..100}, Employee.validates_length_of_login_field_options)
      
      User.validates_length_of_login_field_options = {:yes => "no"}
      assert_equal({:yes => "no"}, User.validates_length_of_login_field_options)
      User.validates_length_of_login_field_options({:within => 3..100})
      assert_equal({:within => 3..100}, User.validates_length_of_login_field_options)
    end
    
    def test_validates_format_of_login_field_options_config
      default = {:with => /\A\w[\w\.+\-_@ ]+\z/, :message => I18n.t('error_messages.login_invalid', :default => "should use only letters, numbers, spaces, and .-_@ please.")}
      assert_equal default, User.validates_format_of_login_field_options
      assert_equal default, Employee.validates_format_of_login_field_options
      
      User.validates_format_of_login_field_options = {:yes => "no"}
      assert_equal({:yes => "no"}, User.validates_format_of_login_field_options)
      User.validates_format_of_login_field_options default
      assert_equal default, User.validates_format_of_login_field_options
    end
    
    def test_validates_uniqueness_of_login_field_options_config
      default = {:case_sensitive => false, :if => "#{User.login_field}_changed?".to_sym}
      assert_equal default, User.validates_uniqueness_of_login_field_options
      
      User.validates_uniqueness_of_login_field_options = {:yes => "no"}
      assert_equal({:yes => "no"}, User.validates_uniqueness_of_login_field_options)
      User.validates_uniqueness_of_login_field_options default
      assert_equal default, User.validates_uniqueness_of_login_field_options
    end
    
    def test_validates_length_of_login_field
      u = User.new
      u.login = "a"
      assert !u.valid?
      assert u.errors.keys.include?(:login)
      
      u.login = "aaaaaaaaaa"
      assert !u.valid?
      assert !u.errors.keys.include?(:login)
    end
    
    def test_validates_format_of_login_field
      u = User.new
      u.login = "fdsf@^&*"
      assert !u.valid?
      assert u.errors.keys.include?(:login)
      
      u.login = "fdsfdsfdsfdsfs"
      assert !u.valid?
      assert !u.errors.keys.include?(:login)
      
      u.login = "dakota.dux+1@gmail.com"
      assert !u.valid?
      assert !u.errors.keys.include?(:login)
    end
    
    def test_validates_uniqueness_of_login_field
      u = User.new
      u.login = "bjohnson"
      assert !u.valid?
      assert u.errors.keys.include?(:login)
      
      u.login = "BJOHNSON"
      assert !u.valid?
      assert u.errors.keys.include?(:login)

      u.login = "fdsfdsf"
      assert !u.valid?
      assert !u.errors.keys.include?(:login)
    end
    
    def test_find_by_smart_case_login_field
      reset_users
      
      assert_equal users(:ben)[:_id], User.find_by_smart_case_login_field("bjohnson")[:_id]
      assert_equal users(:ben)[:_id], User.find_by_smart_case_login_field("BJOHNSON")[:_id]
      assert_equal users(:ben)[:_id], User.find_by_smart_case_login_field("Bjohnson")[:_id]
      
      reset_employees
      
      assert_equal employees(:drew)[:_id], Employee.find_by_smart_case_login_field("dgainor@binarylogic.com")[:_id]
      assert_equal employees(:drew)[:_id], Employee.find_by_smart_case_login_field("Dgainor@binarylogic.com")[:_id]
      assert_equal employees(:drew)[:_id], Employee.find_by_smart_case_login_field("DGAINOR@BINARYLOGIC.COM")[:_id]
      
    end
  end
end