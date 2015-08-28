module Commands
  class Touch < Command
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
