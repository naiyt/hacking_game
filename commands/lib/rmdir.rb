module Commands
  class Rmdir < Command
    def run
      begin
        fs.rmdir args[0]
        nil
      rescue Filesystem::FileDoesNotExistError
        "rmdir: #{args[0]} does not exist"
      rescue Filesystem::DirectoryNotEmptyError
        "rmdir: #{args[0]} is not empty"
      end
    end
  end
end
