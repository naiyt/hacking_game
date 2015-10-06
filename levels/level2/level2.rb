# Goals of this level:
# Teach the following commands:
# time, ls, pwd

module ShellSim
  module Scripts
    module Level2
      def self.play
        Script.new do
          level_name 'Level 2'

          available_commands [:help, :man, :time, :ls, :pwd]

          output "Command(s) unlocked: time, ls, pwd", :info

          expect_cmd :time, "Certain commands take 'arguments', like 'man'. Other commands do not. One example is the 'time' command. Use it now."

          expect_cmd :ls, "The shell lets you view and interact with files and directories. To view the contents of the current directory use the 'ls' command."

          expect_cmd :pwd, "Before we learn how to navigate the filesystem, it is important to know how to identify your current location -- this is viewable in your command prompt. You can also use the 'pwd' command. Do so now."
        end
      end
    end
  end
end

