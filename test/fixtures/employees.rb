def create_drew
  e = Employee.new
  e.company= "binary_logic"
  e.email= "dgainor@binarylogic.com"
  e.password_salt = salt = Authlogic::Random.hex_token
  e.crypted_password = Employee.crypto_provider.encrypt("drewrocks" + salt)
  e.persistence_token= "5273d85ed156e9dbd6a7c1438d319ef8c8d41dd24368db6c222de11346c7b11e53ee08d45ecf619b1c1dc91233d22b372482b751b066d0a6f6f9bac42eacaabf"
  e.first_name = "Drew"
  e.last_name = "Gainor"
  e.save_without_callbacks
  e
end
  
def create_jennifer
  e = Employee.new
  e.company = "logic_over_data"
  e.email = "jenjohnson@logicoverdata.com"
  e.password_salt = salt = Authlogic::Random.hex_token
  e.crypted_password = Employee.crypto_provider.encrypt("jenniferocks" + salt)
  e.persistence_token = "2be52a8f741ad00056e6f94eb6844d5316527206da7a3a5e3d0e14d19499ef9fe4c47c89b87febb59a2b41a69edfb4733b6b79302040f3de83f297c6991c75a2"
  e.first_name = "Jennifer"
  e.last_name = "Johnson"
  e.save_without_callbacks
  e
end

def employees(key)
  @employees[key]
end

def reset_employees

  Employee.all.each do |e|
    e.destroy
  end

  @employees = {:jennifer => create_jennifer, :drew => create_drew }

end

reset_employees