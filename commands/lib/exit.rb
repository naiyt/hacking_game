module Commands
  class Exit < Command
    def run
      abort
    end
  end
end
