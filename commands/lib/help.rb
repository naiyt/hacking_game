module Commands
  class Help < Command
    def run
      "#{'Available commands'.colorize :green}:\n#{Commands.available_commands.join("\n")}"
    end
  end
end
