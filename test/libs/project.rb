class Project < CouchRest::ExtendedDocument
  use_database ::SERVER.default_database
  include CouchRest::Validation
  include CouchRest::Callbacks
  
  property    :name
  
  timestamps!

  include HasManyUsers
  #has_and_belongs_to_many :users
end