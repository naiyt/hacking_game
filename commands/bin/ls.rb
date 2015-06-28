module Commands
  class Ls < Command
    def run
      contents = Filesystem::Filesystem.instance.pwd.ls
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
