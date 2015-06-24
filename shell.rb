require_relative 'commands'

class Shell

  def initialize(prompt="[cmd]: ")
    @prompt = prompt
    puts "Welcome to a sweet shell! Type help for help"
  end

  def run
    begin
      while true
        print @prompt
        input = gets.chomp.split("\s")
        cmd = input[0]
        args = input[1..-1]
        exec_cmd(cmd.to_sym, args) unless cmd == ''
      end
    rescue SystemExit, Interrupt
      abort
    end
  end

  def exec_cmd(cmd, args)
    if command_available?(cmd)
      puts Commands.send(cmd, *args)
    else
      puts "Command not found: #{cmd}"
    end
  end

  def command_available?(cmd)
    Commands::AVAILABLE_COMMANDS.include? cmd
  end
end
