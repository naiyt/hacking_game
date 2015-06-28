module Commands
  class Ls < Command
    def run
      if args.length > 0 && args[0][0] != '-'
        contents = Filesystem::Filesystem.instance.ls args[0]
      else
        contents = Filesystem::Filesystem.instance.pwd.ls
      end
      contents.select! { |d| d[0] != '.' } unless all?
      contents.join delimiter
    end

    def all?
      args.include? '-a'
    end

    def delimiter
      '   '
    end
  end
end
