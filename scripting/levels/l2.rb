module Scripts
  module Level2
    def self.play
      Script.new do
        level_name 'Level 2'

        available_commands [:help, :pwd, :ls, :man, :exit, :cd, :mkdir, :touch, :filetype]

        output "You will now learn about navigating the filesystem.", :info

        output "We have given you access to more commands. Use the history command if you want to see them.", :info

        expect_cmd :ls, "Remember that you can list the files in your current directory with 'ls'. Do so now." do
          output "Good. Currently there are only directories.", :info
        end

        expect_cmd_with_args :ls, :tmp, "You can also pass a directory argument into ls in order to view the contents of that directory. View the contents of tmp." do
          output "You'll notice that the tmp directory is empty", :info
        end

        expect_cmd_with_args :cd, :tmp, "Let's put something in tmp. First, we want to change our current directory to tmp. Do that with the 'cd' command. (If you get lost, you can always type 'cd' with no args to return to the root directory. And don't forget 'pwd'.)" do
          expect_cmd :pwd, "Use pwd to confirm you are inside of tmp" do
            output "Good.", :info
          end
        end

        expect_cmd_with_args :touch, :"hax.txt", "'touch' is useful for several things. One is for creating empty files. Use touch to create a file called 'hax.txt'" do
          output "If you want, you can use ls to confirm the file was created.", :info
        end

        expect_cmd_with_args :mkdir, :mysecretfiles, "'mkdir' is similar in that it can be used to create directories. Create a directory in tmp called 'mysecretfiles'." do
          output "Now tmp has a subdirectory 'mysecretfiles'. You can verify this with ls.", :info
        end

        expect_cmd_with_args :filetype, :"hax.txt", "Use the 'filetype' command on hax.txt. This is helpful if you are unsure if something is a file or a directory." do
          expect_cmd_with_args :filetype, :mysecretfiles, "Now do the same for mysecretfiles" do
          end
        end

        expect_cmd_with_args :cd, :"..", "We can return to the root directory using the '..' shortcut. '..' always refers to your parent directory" do
          output "Good. Once again you can use pwd to confirm that you are in the root directory.", :info
        end
      end
    end
  end
end
