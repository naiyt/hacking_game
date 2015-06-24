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
        cmds = get_input
        cmds.each { |cmd| exec_cmd(cmd[:cmd], cmd[:args]) }
      end
    rescue SystemExit, Interrupt
      abort
    end
  end

  private

  def get_input
    # "ls | echo blah"" becomes [{cmd: 'ls', args:[]}, {cmd: 'echo', args: ['blah']}]
    input = gets.chomp.split("|").map { |x| x.split("\s") }
    input.map { |x| {cmd: x[0].to_sym, args: x[1..-1]} }
  end

  def exec_cmd(cmd, args)
    if command_available?(cmd)
      Commands.send(cmd, *args)
    else
      puts "Command not found: #{cmd}"
    end
  end

  def command_available?(cmd)
    Commands::AVAILABLE_COMMANDS.include? cmd
  end
end
