class Employee < CouchRest::ExtendedDocument
  use_database SERVER.default_database

  include CouchRest::Validation
  include CouchRest::Callbacks

  attr_accessor :password_confirmation

  property    :company_id
  property    :email
  property    :crypted_password
  property    :password_salt
  property    :persistence_token
  property    :first_name
  property    :last_name
  property    :login_count, :default => 0, :type => Integer
  property    :last_request_at, :cast_as => 'Time'
  property    :current_login_at, :cast_as => 'Time'
  property    :last_login_at, :cast_as => 'Time'
  property    :current_login_ip
  property    :last_login_ip

  timestamps!

  
  acts_as_authentic do |c|
    c.crypto_provider Authlogic::CryptoProviders::AES256
  end
  
  include BelongsToCompany
  
end