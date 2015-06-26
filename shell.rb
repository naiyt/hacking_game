require_relative 'commands/commands_helper'

class Shell

  def initialize(prompt="[cmd]: ")
    @prompt = prompt
    @runner = Commands::CommandRunner.instance
    puts "Welcome to a sweet shell! Type help for help"
  end

  def run
    begin
      while true
        print @prompt
        cmds = get_input
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

  def exec_cmds(cmds)
    next_input = default_in
    cmds.each do |cmd|
      cmd_sym, cmd_args = cmd[:cmd], cmd[:args]
      if command_available?(cmd_sym)
        next_input = @runner.execute(cmd_sym, cmd_args, next_input)
      else
        puts "Command not found: #{cmd_sym}"
      end
    end
    puts next_input unless next_input == default_in
  end

  def command_available?(cmd)
    Commands::AVAILABLE_COMMANDS.include? cmd
  end

  def default_in
    Commands::STDIN
  end
end
