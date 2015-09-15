module Scripts
  module Level3
    def self.play
      Script.new do
        level_name 'Level 3'

        available_commands [:help, :pwd, :ls, :man, :exit, :cd, :touch, :filetype]

        output "YOU HAVE UNLOCKED 'touch' AND 'filetype'", :info

        output "FILE BASICS", :info

        expect_cmd_with_args :man, :touch, "READ THE MANUAL FOR 'touch'"

        expect_file_to_exist "/hax.txt", "USE THE TOUCH COMMAND TO CREATE AN EMPTY FILE CALLED 'hax.txt' INSIDE /"

        expect_cmd_with_args :man, :filetype, "READ THE MANUAL FOR 'filetype'"

        expect_cmd_with_args :filetype, :"hax.txt", "DISCOVER THE FILETYPE OF 'hax.txt'"

        expect_cmd_with_args :filetype, :"tmp", "DISCOVER THE FILETYPE OF 'tmp'"
      end
    end
  end
end

