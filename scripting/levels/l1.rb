module Scripts
  module Level1
    def self.play
      Script.new do
        level_name 'Level 1'
        output 'Welcome to a sweet thing!'

        expect_cmd :help, 'Type in "help" to get a list of commands' do
          output 'Success! You are 1337 haxor', :info
        end

        expect_cmd :pwd, 'Use the command "pwd" to get your current location!' do
          output "Success! Now you'll always now where you are.", :info
        end

        expect_cmd :ls, '"ls" can be used to get a list of files and directories' do
          output 'Nice job! We call them "Directories" not folders, FYI', :info
        end

        expect_cmd_with_args :man, [:man], 'manual pages can be used with the "man" command. Read the manual page for the man command' do
          output 'Nice job, man', :info
        end

        run_playground 'This level is over, but you can keeping playing with the commands you have learned'
      end
    end
  end
end
