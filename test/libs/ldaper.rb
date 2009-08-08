class Ldaper < CouchRest::ExtendedDocument
  use_database SERVER.default_database
  
  include CouchRest::Validation
  include CouchRest::Callbacks
  
  property    :ldap_login
  property    :persistence_token
  
  timestamps!
  
  acts_as_authentic
end