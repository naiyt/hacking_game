# Goals of this level
# - Teach about navigating with cd
# - Teach relative and absolute paths

module ShellSim
  module Scripts
    module Level3
      def self.play
        Script.new do
          level_name 'Level 3'

          available_commands [:help, :man, :time, :ls, :pwd, :cd]

          output "Command(s) unlocked: cd", :info

          output "Learning to navigate quickly through the filesystem is crucial. The main command used to do so is 'cd' (short for 'change directory').", :info

          expect_cmd :ls, "First, use 'ls' to check the contents of the current directory again."

          output "All of those names are directories contained inside of your current directory. Any name that 'ls' prints as blue is a directory.", :info

          expect_pwd_to_be '/usr', "We would like to change our current directory to 'usr'. To do so, use the command 'cd usr'."

          expect_cmd :pwd, "Confirm your location with 'pwd'."

          output "Now, what if we wanted to return to our original directory, or some other directory?", :info

          output "To do so, we must learn about the difference between 'relative' and 'absolute' paths.", :info

          output "When we used the command 'cd usr' we used a 'relative' path. This is because the path 'usr' was relative to our current location inside of the root directory '/'.", :info

          output "If you look at our current location, it is actually '/usr'. That is the 'absolute' or 'full' path of the current directory.", :info

          output "Anytime you reference a directory with a command like 'cd', you can do so with either it's 'absolute' or 'relative' path.", :info

          expect_pwd_to_be '/tmp', "This means we can easily reach the directory '/tmp' directly from '/usr', by using its absolute path! Do so now."

          expect_cmd_with_args :ls, :'/', "You can also reference absolute paths with 'ls'. Take a look at the contents of the root directory '/' again by using the command 'ls /'."

          output "Remember, if you use 'ls' with no arguments, it will list the contents of the current directory. You can also pass it a filepath (relative or absolute) to look at the contents of another directory.", :info
        end
      end
    end
  end
end

