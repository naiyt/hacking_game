module Scripts
  module Level1
    def self.play
      Script.new do
        level_name 'Tutorial'

        available_commands [:help, :pwd, :ls, :man, :exit]

        output "HAKSH welcomes you. You will be guided through the basics of this system.", :info

        expect_cmd :help, "'help' will show you a list of commands. As you prove your skills more commands will be made available." do
          output 'Success. You can use the help command at any time to view your currently available commands.', :info
        end

        expect_cmd :pwd, "'pwd' will tell you where you are in the filesystem." do
          output 'Success. Use pwd whenever you are unsure of your location', :info
        end

        expect_cmd :ls, "'ls' will list the contents of the current directory" do
          output 'Success. Contents can be files or directories.', :info
        end

        expect_cmd_with_args :man, [:man], "You can learn more about commands with the 'man' command. man is short for manual. Read the manual for the 'man' command." do
          output 'Some commands may be missing a manual page.', :info
        end

        run_playground 'This level is now over. You may now use the commands you have learned thus far freely.'
      end
    end
  end
end
