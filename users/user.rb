module Users
  class InvalidPasswordError < StandardError
  end

  class UserDoesNotExistError < StandardError
  end

  def self.users
    @users ||= load_users
  end

  def self.reload_users(users_file)
    @users = load_users(users_file)
  end

  def self.load_users(users_file='./users/passwd.yml')
    data = YAML.load_file(users_file)
    data.map.with_object({}) do |(user_name, user_data), hash|
      new_user = User.new(user_name, user_data["password"], user_data["super_user"])
      hash[user_name] = new_user
    end
  end

  def self.login(user_name, user_pass)
    raise UserDoesNotExistError if users[user_name].nil?
    raise InvalidPasswordError if users[user_name].password != user_pass
    users[user_name]
  end

  class User
    attr_reader :name, :password, :super_user

    def initialize(name, password, super_user=false)
      @name = name
      @password = password
      @super_user = super_user
    end
  end
end

