module Commands
  class Mkdir < Command
    def run
      begin
        fs.mkdir args[0]
        nil
      rescue Filesystem::FileNotDir => message
        message.to_s
      end
    end
  end
end
