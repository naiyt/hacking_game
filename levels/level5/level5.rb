module ShellSim
  module Scripts
    module Level5
      def self.play
        Script.new do
          level_name 'Logging in as users'

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
end
