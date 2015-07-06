module Scripts
  require_relative '../shell.rb'
  Dir['scripting/levels/*.rb'].each { |file| require File.expand_path file }

  def self.shell
    @shell ||= Shell.new
  end

  class Script
    include Commands::OutputHelper
    attr_accessor :shell, :name

    def initialize(&block)
      @shell = Scripts.shell
      instance_eval(&block)
    end

    # DSL methods

    def level_name(n)
      @name = n
    end

    def output(text, type=:standard)
      # sends to the Commands::OutputHelper methods
      puts self.send(type, text) unless text.nil?
    end

    def expect_cmd(cmd, txt=nil)
      output(txt, :info)
      next_cmds until latest_cmd?(cmd)
      yield
    end

    def expect_cmd_with_args(cmd, args, txt=nil)
      output(txt, :info)
      next_cmds until (latest_cmd?(cmd) && latest_args?(args))
      yield
    end

    def run_playground(txt=nil)
      output(txt, :info)
      @shell.run(forever=true)
    end

    def greeting
      output("Welcome to #{@name}", :info)
    end

    def available_commands(cmds)
      Commands.available_commands = cmds
    end

    private

    def next_cmds
      @shell.run(forever=false) do |res, cmds|
        @latest_cmds = cmds
        @latest_res = res
      end
    end

    def latest_cmd?(cmd)
      unless @latest_cmds.nil?
        @latest_cmds.map { |c| c[:cmd] }.include? cmd.to_sym
      end
    end

    def latest_args?(args)
      unless @latest_cmds.nil?
        args == @latest_cmds.map { |c| c[:args].map { |a| a.to_sym} }.flatten
      end
    end
  end
end
