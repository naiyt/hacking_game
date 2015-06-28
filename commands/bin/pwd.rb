module Commands
  class Pwd < Command
    def run
      Filesystem::Filesystem.instance.pwd.path_to
    end
  end
end
