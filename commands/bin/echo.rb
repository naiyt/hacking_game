module Commands
  class Echo < Command
    def run
      args.length > 0 ? args.join(" ") : input
    end
  end
end
