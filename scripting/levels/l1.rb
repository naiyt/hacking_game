module Scripts
  module Level1
    def self.play
      Script.new do
        level_name 'Level 1'
        output 'Welcome to a sweet thing! Ask for help to beat the first level'
        run_level
        expect_cmd :help do
          puts 'Success! You are 1337 haxor'
        end
        output 'You have beaten level 1! Congratulations!'
        run_playground
      end
    end
  end
end
