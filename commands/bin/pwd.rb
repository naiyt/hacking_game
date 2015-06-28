module Commands
  class Pwd < Command
    def run
      fs.instance.pwd.path_to
    end
  end
end
