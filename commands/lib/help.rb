module Commands
  class Help < Command
    def run
      "Available commands:\n#{AVAILABLE_COMMANDS.join("\n")}"
    end
  end
end
