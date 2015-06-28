module Commands
  class Mkdir < Command
    def run
      Filesystem::Filesystem.instance.mkdir args[0]
      nil
    end
  end
end