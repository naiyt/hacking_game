module ShellSim
  module Scripts
    module Level2
      def self.play
        Script.new do
          level_name 'Level 2'

          available_commands [:help, :pwd, :ls, :man, :exit, :cd]

          output "COMMAND(S) UNLOCKED: 'cd'", :info

          output "YOU MUST LEARN TO NAVIGATE THE FILESYSTEM.", :info

          expect_cmd_with_args :man, :cd, "READ THE MANUAL FOR 'cd'"

          expect_pwd_to_be "/tmp", "CHANGE DIRECTORIES TO /tmp"

          output "YOU CAN NAVIGATE TO A DIRECTORY'S PARENT BY USING .. OR TYPING ITS FULL PATH", :info

          expect_pwd_to_be "/", "NAVIGATE TO / WITH EITHER 'cd ..' OR 'cd /tmp'"

          output "FIN."
        end
      end
    end
  end
end

