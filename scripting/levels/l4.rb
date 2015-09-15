module Scripts
  module Level4
    def self.play
      Script.new do
        level_name 'Level 4'

        available_commands [:help, :pwd, :ls, :man, :exit, :cd, :touch, :filetype, :cat]

        output "INTRODUCTION TO FILES"

        output "YOU HAVE UNLOCKED 'cat'", :info

        expect_cmd_with_args :man, :cat, "READ THE MANUAL FOR 'cat'"

        run_playground
      end
    end
  end
end

