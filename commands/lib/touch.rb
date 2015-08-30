module Commands
  class Touch < Command
    def self.manual
      <<-EOS
touch - update timestamps and create files

If the file or directory exists, its timestamp will be updated.

If nothing exists at the specified path an empty file will be created with that name.

stdin: no
stdout: no
      EOS
    end

    def run
      begin
        fs.create_file(args[0])
        nil
      rescue Filesystem::FileAlreadyExists
        nil
      rescue Filesystem::FileDoesNotExistError
        {stderr: "path does not exist"}
      rescue Filesystem::FileNotDir => message
        {stderr: message.to_s}
      end
    end
  end
end
