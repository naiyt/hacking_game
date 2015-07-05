module Commands
  class Help < Command
    def run
      "#{'Available commands'.colorize :green}:\n#{AVAILABLE_COMMANDS.join("\n")}"
    end
  end
end
