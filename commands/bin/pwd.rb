module Commands
  class Pwd < Command
    def run
      fs.pwd.path_to
    end
  end
end
