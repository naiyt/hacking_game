module Commands
  class Cd < Command
    def run
      begin
        dir = args[0].nil? ? '/' : args[0]
        fs.cd dir
        nil
      rescue Filesystem::FileDoesNotExistError
        {stderr: "#{args[0]} does not exist"}
      end
    end
  end
end
