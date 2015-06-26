require_relative 'commands/commands_helper'
require_relative 'filesystem/filesystem'

class Shell
  def initialize(debug=false, prompt="[cmd]: ")
    @prompt = prompt
    @debug = debug
    @runner = Commands::CommandRunner.instance
    puts "Welcome to a sweet shell! Type help for help"
  end

  def run
    begin
      while true
        print @prompt
        cmds = get_input
        p cmds if @debug
        exec_cmds(cmds)
      end
    rescue SystemExit, Interrupt
      abort
    end
  end

  private

  def get_input
    # TODO: Only works with single quotes so far

    # Split commands by pipes
    input = gets.chomp.split("|")

    # Strip beginning and ending whitespace
    input = input.map { |x| x.strip }

    # Split by words or "quoted words"
    input = input.map { |x| x.split(/\s(?=(?:[^"]|"[^"]*")*$)/) } # http://stackoverflow.com/a/11566264/1026980

    # Remove quotes
    input = input.map { |x| x.map { |y| y.gsub '"', ''} }

    # Turn into list of hashes: "grep blah | echo"" => [{cmd: 'grep', args:['blah']}, {cmd: 'echo', args: []}]
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
