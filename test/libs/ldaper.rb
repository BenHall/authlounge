class Ldaper < CouchRest::ExtendedDocument
  use_database SERVER.default_database
  
  include CouchRest::Validation
  include CouchRest::Callbacks
  
  property    :login
  property    :ldap_login
  property    :persistence_token
  property    :email
  
  timestamps!
  
  acts_as_authentic
end