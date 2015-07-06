module Commands
  class Man < Command
    def self.manual
      "Cool man page"
    end

    def self.usage
      "Usage: man [command name]"
    end

    def run
      cmd = args[0]
      if cmd.nil?
        self.class.usage
      elsif !Shell.command_available? cmd
        {stderr: "Command not found: #{cmd}"}
      else
        klass = @runner.get_class args[0]
        begin
          klass.manual
        rescue NoMethodError
          {stderr: "#{cmd}: no manual found"}
        end
      end
    end
  end
end
