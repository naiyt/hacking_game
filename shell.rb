require_relative 'commands'

class Shell

  def initialize(prompt="[cmd]: ")
    @prompt = prompt
  end

  def run
    begin
      while true
        print @prompt
        cmd = gets.chomp
        exec_cmd(cmd.to_sym) unless cmd == ''
      end
    rescue SystemExit, Interrupt
      abort
    end
  end

  def exec_cmd(cmd)
    if command_available?(cmd)
      Commands.send(cmd)
    else
      puts "Command not found: #{cmd}"
    end
  end

  def command_available?(cmd)
    Commands::AVAILABLE_COMMANDS.include? cmd
  end
end
