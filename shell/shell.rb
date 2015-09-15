require_relative '../commands/commands_helper'
require_relative '../filesystem/filesystem'
require_relative '../users/user'
require 'highline/import'

class Shell
  include Commands::OutputHelper

  attr_accessor :history, :user

  def initialize(user_name, user_pass, debug=false)
    login(user_name, user_pass)
    @debug = debug
    @runner = Commands::CommandRunner.instance
    @history = []
    @fs = Filesystem::Filesystem.instance
  rescue Users::UserDoesNotExistError
    abort("User #{user_name} does not exist")
  rescue Users::InvalidPasswordError
    abort("Invalid password for #{user_name}")
  end

  def login(user_name, user_pass)
    @user = Users.login(user_name, user_pass)
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
    input = ask(prompt) { |q| q.readline = true }
    @history << input
    format_input(input)
  end

  def prompt
    path = @fs.pwd.path_to
    "[#{@user.name}@hacksh #{path}]: "
  end

  def format_input(input)
    # Split commands by pipes
    input = input.split("|")

    # Strip beginning and ending whitespace
    input = input.map { |x| x.strip }

    # Split by words or "quoted words"
    # http://stackoverflow.com/a/11566264/1026980
    input = input.map { |x| x.split(/\s(?=(?:[^"]|"[^"]*")*$)/) }

    # Remove quotes
    input = input.map { |x| x.map { |y| y.gsub '"', ''} }

    # Turn into list of hashes:
    # e.g.: "grep blah | echo"" => [{cmd: 'grep', args:['blah']}, {cmd: 'echo', args: []}]
    input = input.map { |x| {cmd: x[0].to_sym, args: x[1..-1]} }

    # Parse for stdout redirection ( > and >> )
    input = input.map { |x| parse_redirects(x) }

    input
  end

  def parse_redirects(cmd)
    overwrite_index = cmd[:args].index ">"
    append_index = cmd[:args].index ">>"
    splice_index = !overwrite_index.nil? ? overwrite_index : append_index
    if splice_index
      file_name = cmd[:args][splice_index+1]
      cmd[:args] = cmd[:args][0...splice_index]
      cmd[:redirect] = { append: !append_index.nil?, file_name: file_name }
    end
    cmd
  end

  def exec_cmds(cmds)
    next_input = default_in
    cmds.each do |cmd|
      cmd_sym, cmd_args, cmd_redirect = cmd[:cmd], cmd[:args], cmd[:redirect]
      if self.class.command_available?(cmd_sym)
        next_input = @runner.execute(cmd_sym, cmd_args, next_input)
        next_input = redirect_out(next_input.uncolorize, cmd_redirect) if cmd_redirect
      else
        return {:stderr => "Command not found: #{cmd_sym}" }
      end
    end
    next_input
  end

  def redirect_out(data, redirect_hash)
    if @fs.file_exists? redirect_hash[:file_name]
      file = @fs.get_file(redirect_hash[:file_name])
    else
      begin
        file = @fs.create_file(redirect_hash[:file_name])
      rescue Filesystem::FileDoesNotExistError
        return "Error: the path #{redirect_hash[:file_name]} does not exist"
      end
    end

    if redirect_hash[:append] && !file.data.nil?
      file.data += data
    else
      file.data = data
    end
    nil
  end

  def self.command_available?(cmd)
    Commands.available_commands.include? cmd.to_sym
  end

  def default_in
    Commands::STDIN
  end
end

