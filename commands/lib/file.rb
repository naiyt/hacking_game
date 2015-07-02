module Commands
  class Filetype < Command
    def run
      type = fs.file_type args[0]
      return "File" if type == Filesystem::File
      return "Directory" if type == Filesystem::Directory
    end
  end
end
