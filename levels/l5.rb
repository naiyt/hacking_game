module Scripts
  module Level5
    def self.play
      Script.new do
        level_name 'Logging in as users'

        load_users_file './scripting/users/l1.yml'

        login_as 'jan'

        available_commands [:help, :pwd, :ls, :man, :exit, :cd, :touch, :filetype, :cat, :login]

        output "YOU HAVE UNLOCKED 'login'", :info

        output "LOGIN AS ROOT", :info

        expect_current_user_to_be :root do
          output "YOU DEFEATED", :info
        end

        run_playground
      end
    end
  end
end

