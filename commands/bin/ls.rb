module Commands
  class Ls < Command
    def run
      Filesystem::Filesystem.instance.pwd.ls
    end
  end
end
