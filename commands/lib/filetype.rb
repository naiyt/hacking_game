module Commands
  class Filetype < Command
    def self.manual
      <<-EOS
filetype: prints the filtype of a filesystem object

stdin: no
stdout: yes
      EOS
    end

    def run
      type = fs.file_type args[0]
      return "File" if type == Filesystem::File
      return "Directory" if type == Filesystem::Directory
    end
  end
end
