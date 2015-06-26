module Commands
  class Time < Command
    def run
      ::Time.now
    end
  end
end
