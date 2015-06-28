module Commands
  class Cd < Command
    def run
      fs.cd args[0]
      nil
    end
  end
end
