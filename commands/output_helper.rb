require 'colorize'

# This is a mixin to help with outputting colored text
# Use "include Commands::OutputHelper" in your class

module Commands
  module OutputHelper
    def info(txt)
      txt.colorize :green
    end

    def error(txt)
      txt.colorize :red
    end

    def color_dir(txt)
      txt.colorize :blue
    end

    def color_file(txt)
      txt
    end

    def standard(txt)
      txt
    end
  end
end
