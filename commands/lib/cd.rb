module Commands
  class Cd < Command
    def self.manual
      <<-EOS
cd - change directories.

USAGE: cd [directory_name or path]

EXAMPLE:

[prompt]: pwd
/
[prompt]: ls
tmp usr
[prompt]: cd tmp
[prompt]: pwd
/tmp
[prompt]: cd /usr
[prompt]: pwd
/usr

stdin: no
stdout: no
      EOS
    end

    def run
      begin
        dir = args[0].nil? ? '/' : args[0]
        fs.cd dir
        nil
      rescue Filesystem::FileDoesNotExistError
        {stderr: "#{args[0]} does not exist"}
      end
    end
  end
end
