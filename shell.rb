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
        cmds = set_call_chain(cmds) unless cmds.length == 0
        exec_cmds(cmds)
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

  def set_call_chain(cmds)
    cmds[0][:stdin] = Commands::STDIN
    cmds = cmds.map.each_with_index do |cmd, i|
      prev_cmd = cmds[i-1]
      prev_cmd[:stdout] = lambda { exec_cmd(cmd) }
      cmd
    end
    cmds[-1][:stdout] = Commands::STDOUT
    cmds
  end

  def exec_cmds(cmds)
    result = Commands::STDIN
    cmds.each do |cmd|
      cmd_sym = cmd[:cmd]
      cmd_args = cmd[:args]
      if command_available?(cmd_sym)
        result = Commands.send(cmd_sym, args=cmd_args, input=result)
      else
        puts "Command not found: #{cmd_sym}"
      end
    end
    puts result unless result == Commands::STDIN
  end

  def command_available?(cmd)
    Commands::AVAILABLE_COMMANDS.include? cmd
  end
end
