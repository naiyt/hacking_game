module Commands
  class History < Command
    def run
      history = @runner.shell.history.select { |cmd| cmd != 'history' }
      history.join("\n")
    end
  end
end