module Commands
  class Cd < Command
    def run
      Filesystem::Filesystem.instance.cd args[0]
    end
  end
end
