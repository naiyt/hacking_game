module Commands
  class Grep < Command
    def run
      @search_query = args[0]
      if from_stdin?
        grep_from_stdin
      else
        grep_from_input
      end
    end

    private

    def grep_from_stdin
      while next_line = get_input
        next_line = next_line.chomp
        puts next_line if matches?(next_line, @search_query)
      end
    end

    def grep_from_input
      input = get_input
      input if matches?(input, @search_query)
    end

    def matches?(text, query)
      text.include? query
    end
  end
end
