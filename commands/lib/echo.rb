module Commands
  class Echo < Command
    def run
      args.length > 0 ? args.join(" ") : get_input
    end
  end
end
