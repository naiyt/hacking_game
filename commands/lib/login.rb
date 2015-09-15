module Commands
  class Login < Command
    def self.manual
      <<-EOS
login - login as a user

USAGE: login username userpass
      EOS
    end

    def run
      user_name = args[0]
      pass = args[1]
      @runner.shell.login(user_name, pass)
    rescue Users::UserDoesNotExistError
      { stderr: "User #{user_name} does not exist" }
    rescue Users::InvalidPasswordError
      { stderr: "Invalid password for #{user_name}" }
    end
  end
end

