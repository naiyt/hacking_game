module Commands
  class Cd < Command
    def run
      begin
        fs.cd args[0]
        nil
      rescue Filesystem::FileDoesNotExistError
        "#{args[0]} does not exist"
      end
    end
  end
end
