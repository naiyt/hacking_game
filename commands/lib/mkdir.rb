module Commands
  class Mkdir < Command
    def run
      fs.mkdir args[0]
      nil
    end
  end
end
