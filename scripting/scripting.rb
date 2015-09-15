module Scripts
  require_relative '../shell/shell.rb'
  Dir['scripting/levels/*.rb'].each { |file| require File.expand_path file }

  def self.shell
    @shell ||= Shell.new('nate', 'password') # TODO - actually setup a game user
  end

  class Script
    include Commands::OutputHelper
    attr_accessor :shell, :name

    def initialize(&block)
      @shell = Scripts.shell
      @fs = Filesystem::Filesystem.instance
      instance_eval(&block)
    end

    # DSL methods

    def level_name(n)
      @name = n
    end

    def load_users_file(file_name)
      Users.reload_users(file_name)
    end

    def login_as(user_name)
      @shell.user = Users.users[user_name] # bypasses authentication
    end

    def output(text, type=:standard)
      # sends to the Commands::OutputHelper methods
      puts self.send(type, text) unless text.nil?
    end

    def expectation(txt)
      output(txt, :info)
      until yield
        output("CURRENT TASK: #{txt}", :info) if is_latest_cmd?('task')
        next_cmds
      end
    end

    def expect_cmd(cmd, txt=nil)
      expectation(txt) { is_latest_cmd?(cmd) }
      yield if block_given?
    end

    def expect_cmd_with_args(cmd, args, txt=nil)
      expectation(txt) { is_latest_cmd?(cmd) && is_latest_args?(Array(args)) }
      yield if block_given?
    end

    def expect_pwd_to_be(dir, txt=nil)
      expectation(txt) { @fs.pwd.path_to == dir }
      yield if block_given?
    end

    def expect_file_to_exist(filepath, txt=nil)
      expectation(txt) { @fs.file_exists?(filepath) }
      yield if block_given?
    end

    def expect_dir_to_exist(dir_name, txt=nil)
      raise
    end

    def expect_current_user_to_be(user_name, txt=nil)
      expectation(txt) { @shell.user.name.to_sym == user_name }
      yield if block_given?
    end

    def run_playground(txt=nil)
      output(txt, :info)
      @shell.run(forever: true)
    end

    def greeting
      output("Welcome to #{@name}", :info)
    end

    def available_commands(cmds)
      cmds << :task
      Commands.available_commands = cmds
    end

    private

    def next_cmds
      @shell.run(forever=false) do |res, cmds|
        @latest_cmds = cmds
        @latest_res = res
      end
    end

    def is_latest_cmd?(cmd)
      unless @latest_cmds.nil?
        @latest_cmds.map { |c| c[:cmd] }.include? cmd.to_sym
      end
    end

    def is_latest_args?(args)
      unless @latest_cmds.nil?
        args == @latest_cmds.map { |c| c[:args].map { |a| a.to_sym} }.flatten
      end
    end
  end
end
