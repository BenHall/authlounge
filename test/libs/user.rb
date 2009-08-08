class User < CouchRest::ExtendedDocument
  use_database SERVER.default_database
  include CouchRest::Validation
  include CouchRest::Callbacks

  attr_accessor :password_confirmation

  property   :company_id
  property    :login
  property    :crypted_password
  property    :password_salt
  property    :persistence_token
  property    :single_access_token
  property    :perishable_token
  property    :email
  property    :first_name
  property    :last_name
  property    :login_count, :default => 0, :type => Integer
  property    :failed_login_count, :default => 0, :type => Integer
  property    :last_request_at, :cast_as => 'Time', :default => 100.years.ago.utc
  property    :last_login_at, :cast_as => 'Time', :default => 100.years.ago.utc
  property    :current_login_at, :cast_as => 'Time'
  property    :current_login_ip
  property    :last_login_ip
  property    :active, :default => true, :cast_as => :boolean
  property    :approved, :default => true, :cast_as => :boolean
  property    :confirmed, :default => true, :cast_as => :boolean

  timestamps!

  acts_as_authentic

  include BelongsToCompany

  #has_and_belongs_to_many :projects
end