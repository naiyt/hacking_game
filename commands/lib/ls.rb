module Commands
  class Ls < Command
    def self.manual
      <<-EOS
ls - list the contents of a directory.

stdout: yes
stdin: no
      EOS
    end

    def run
      begin
        contents = fs.ls_path path
        contents = contents.select { |k,_| k[0] != '.' } unless show_hidden?
        names = colorize(contents)
        names.join delimiter
      rescue Filesystem::FileDoesNotExistError
        { stderr: "ls #{path}: file or directory does not exist" }
      end
    end

    def show_hidden?
      args.include? '-a'
    end

    def delimiter
      '   '
    end

    def path
      args.length > 0 && args[0][0] != '-' ? args[0] : ''
    end

    def colorize(contents)
      contents.map do |name, type|
        if type == :dir
          color_dir(name)
        else
          color_file(name)
        end
      end
    end
  end
end

