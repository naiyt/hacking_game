module Commands
  class Time < Command
    def run
      ::Time.now.to_s
    end
  end
end
