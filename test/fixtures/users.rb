def create_ben

  ben = User.new
  ben.company = "binary_logic"
  #ben.projects = "web_services"
  ben.login = "bjohnson"
  ben.password = "bjohnson"
  ben.password_confirmation = "bjohnson"
  ben.password_salt = salt = Authlogic::Random.hex_token
  ben.crypted_password = Authlogic::CryptoProviders::Sha512.encrypt("benrocks" + salt)
  ben.persistence_token = "6cde0674657a8a313ce952df979de2830309aa4c11ca65805dd00bfdc65dbcc2f5e36718660a1d2e68c1a08c276d996763985d2f06fd3d076eb7bc4d97b1e317"
  ben.single_access_token = Authlogic::Random.friendly_token
  ben.perishable_token = Authlogic::Random.friendly_token
  ben.email = "bjohnson@binarylogic.com"
  ben.first_name = "Ben"
  ben.last_name = "Johnson"

  unless ben.save
    puts ben.errors.inspect
  end
  ben
end

def create_zack

  zack = User.new
  zack.company = "logic_over_data"
  #zack.projects = "web_services"
  zack.password = "zackrocks"
  zack.password_confirmation = "zackrocks"
  zack.login = "zackham"
  zack.password_salt = salt = Authlogic::Random.hex_token
  zack.crypted_password = Authlogic::CryptoProviders::Sha512.encrypt("zackrocks" + salt) 
  zack.persistence_token = "fd3c2d5ce09ab98e7547d21f1b3dcf9158a9a19b5d3022c0402f32ae197019fce3fdbc6614d7ee57d719bae53bb089e30edc9e5d6153e5bc3afca0ac1d320342"
  zack.single_access_token = Authlogic::Random.friendly_token
  zack.email = "zham@ziggityzack.com"
  zack.first_name = "Zack"
  zack.last_name = "Ham"

  unless zack.save
    puts zack.errors.inspect
  end
  zack

end



def users(key)
  @users[key]
end

def reset_users

  User.all.each do |user|
    user.destroy
  end

  @users = {:ben => create_ben, :zack => create_zack}

end

reset_users