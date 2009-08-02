module HasManyUsers
  def users
    User.by_user_id :key => id
  end
end