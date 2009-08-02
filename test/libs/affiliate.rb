class Affiliate < CouchRest::ExtendedDocument
  include CouchRest::Validation
  include CouchRest::Callbacks

  property    :company_id
  property    :username
  property    :pw_hash
  property    :pw_salt
  property    :persistence_token
  property    :email
  
  timestamps!
  
  acts_as_authentic do |c|
    c.crypted_password_field = :pw_hash
  end

  include BelongsToCompany
  
end