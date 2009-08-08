require "test/unit"
require "rubygems"
require "ruby-debug"
require "active_record"
require "couchrest"
require "action_controller"
require "active_record/fixtures"

# A temporary fix to bring active record errors up to speed with rails edge.
# I need to remove this once the new gem is released. This is only here so my tests pass.
class ActiveRecord::Errors
  def [](key)
    value = on(key)
    value.is_a?(Array) ? value : [value].compact
  end
end


RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)
RAILS_ENV = "test"
SERVER = CouchRest.new
DB = "authlounge_#{RAILS_ENV}"
db = SERVER.database(DB)
db.recreate! rescue nil
SERVER.default_database = DB

require File.dirname(__FILE__) + '/../lib/authlogic' unless defined?(Authlogic)
require File.dirname(__FILE__) + '/../lib/authlogic/test_case'
require File.dirname(__FILE__) + '/libs/belongs_to_company'
require File.dirname(__FILE__) + '/libs/has_many_projects'
require File.dirname(__FILE__) + '/libs/has_many_users'
require File.dirname(__FILE__) + '/libs/project'
require File.dirname(__FILE__) + '/libs/affiliate'
require File.dirname(__FILE__) + '/libs/employee'
require File.dirname(__FILE__) + '/libs/employee_session'
require File.dirname(__FILE__) + '/libs/ldaper'
require File.dirname(__FILE__) + '/libs/user'
require File.dirname(__FILE__) + '/libs/user_session'
require File.dirname(__FILE__) + '/libs/company'


Authlogic::CryptoProviders::AES256.key = "myafdsfddddddddddddddddddddddddddddddddddddddddddddddd"

require File.dirname(__FILE__) + '/fixtures/users'
require File.dirname(__FILE__) + '/fixtures/employees'

$COUCHREST_DEBUG = true

class ActiveSupport::TestCase

  include ActiveRecord::TestFixtures
  setup :activate_authlogic
  
  private
    def password_for(user)
      case user
      when users(:ben)
        "benrocks"
      when users(:zack)
        "zackrocks"
      end
    end
    
    def http_basic_auth_for(user = nil, &block)
      unless user.blank?
        controller.http_user = user.login
        controller.http_password = password_for(user)
      end
      yield
      controller.http_user = controller.http_password = nil
    end
    
    def set_cookie_for(user, id = nil)
      controller.cookies["user_credentials"] = {:value => user.persistence_token, :expires => nil}
    end
    
    def unset_cookie
      controller.cookies["user_credentials"] = nil
    end
    
    def set_params_for(user, id = nil)
      controller.params["user_credentials"] = user.single_access_token
    end
    
    def unset_params
      controller.params["user_credentials"] = nil
    end
    
    def set_request_content_type(type)
      controller.request_content_type = type
    end
    
    def unset_request_content_type
      controller.request_content_type = nil
    end
    
    def set_session_for(user, id = nil)
      controller.session["user_credentials"] = user.persistence_token
      controller.session["user_credentials_id"] = user.id
    end
    
    def unset_session
      controller.session["user_credentials"] = controller.session["user_credentials_id"] = nil
    end
end
