require_relative 'commands/commands_helper'
require_relative 'filesystem/filesystem'
require 'highline/import'

class Shell
  include Commands::OutputHelper

  attr_accessor :history

  def initialize(debug=false, prompt="[a13@haksh]: ")
    @prompt = prompt
    @debug = debug
    @runner = Commands::CommandRunner.instance
    @history = []
  end

  def run(forever=true)
    @runner.shell = self
    begin
      if forever
        inner_run_loop while true
      else
        res, cmds = inner_run_loop
        yield res, cmds if block_given?
      end
    rescue SystemExit, Interrupt
      abort
    end
  end

  def inner_run_loop
    cmds = get_input
    res = exec_cmds(cmds)
    output res unless (res == default_in || res.nil?)
    [res, cmds]
  end

  def output(res)
    if res.is_a? Hash
      puts error(res[:stderr]) if res.has_key? :stderr
      puts standard(res[:stdout]) if res.has_key? :stdout
    elsif res.is_a? String
      puts standard res
    end
  end

  def get_input
    # TODO: Only works with single quotes so far

    # Using readline implemented by: https://github.com/JEG2/highline
    input = ask(@prompt) { |q| q.readline = true }
    @history << input
    format_input(input)
  end

  def format_input(input)
    # Split commands by pipes
    input = input.split("|")

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
      if self.class.command_available?(cmd_sym)
        next_input = @runner.execute(cmd_sym, cmd_args, next_input)
      else
        return {:stderr => "Command not found: #{cmd_sym}" }
      end
    end
    next_input
  end

  def self.command_available?(cmd)
    Commands.available_commands.include? cmd.to_sym
  end

  def default_in
    Commands::STDIN
  end
end
