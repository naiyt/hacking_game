module Scripts
  module Level1
    def self.play
      Script.new do
        level_name 'Tutorial'

        available_commands [:help, :pwd, :ls, :man, :exit]

        output "WELCOME. YOU WILL NOW LEARN THE BASICS OF THIS SYSTEM.", :info

        expect_cmd :help, "USE 'help' TO SHOW AVAILABLE COMMANDS." do
          output 'SUCCESS. PROVE YOUR SKILL TO GAIN MORE COMMANDS.', :info
        end

        expect_cmd :pwd, "USE 'pwd' TO PRINT YOUR CURRENT LOCATION. YOUR LOCATION IS ALSO SHOWN IN THE PROMPT."

        expect_cmd :ls, "'ls' WILL LIST THE CONTENTS OF A DIRECTORY."

        expect_cmd_with_args :man, [:ls], "USE 'man' TO READ THE MANUAL PAGE FOR THE COMMAND 'ls'"

        output 'YOU WILL NOW GAIN ACCESS TO MORE COMMANDS.', :info
      end
    end
  end
end
