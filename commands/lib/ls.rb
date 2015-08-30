module Commands
  class Ls < Command
    def self.manual
      <<-EOS
ls - list the contents of a directory.

stdout: yes
stdin: no
      EOS
    end

    def run
      begin
        contents = fs.ls_path path
        contents.select! { |d| d[0] != '.' } unless all?
        contents.join delimiter
      rescue Filesystem::FileDoesNotExistError
        {stderr: "ls #{path}: file or directory does not exist"}
      end
    end

    def all?
      args.include? '-a'
    end

    def delimiter
      '   '
    end

    def path
      args.length > 0 && args[0][0] != '-' ? args[0] : ''
    end
  end
end
