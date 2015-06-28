module Commands
  class Ls < Command
    def run
      contents = fs.ls_path path
      contents.select! { |d| d[0] != '.' } unless all?
      contents.join delimiter
    end

    def all?
      args.include? '-a'
    end

    def delimiter
      '   '
    end

    def path
      args.length > 0 && args[0][0] != '-' ? args[0] : ''
    end
  end
end
