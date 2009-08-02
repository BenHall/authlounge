class Company < CouchRest::ExtendedDocument
  use_database SERVER.default_database

  include CouchRest::Validation
  include CouchRest::Callbacks

  property    :company_id
  property    :email
  property    :crypted_password
  property    :password_salt
  property    :persistence_token
  property    :first_name
  property    :last_name
  property    :login_count, :type => Integer, :default => 0
  property    :last_request_at, :cast_as => 'Time'
  property    :current_login_at, :cast_as => 'Time'
  property    :last_login_at, :cast_as => 'Time'
  property    :current_login_ip
  property    :last_login_ip

  timestamps!

  #authenticates_many :employee_sessions
  #authenticates_many :user_sessions

  def employees
    User.by_employee_id :key => id
  end

  include HasManyUsers

  
end