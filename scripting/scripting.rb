module Scripts
  require_relative '../shell.rb'
  Dir['scripting/levels/*.rb'].each { |file| require File.expand_path file }

  def self.shell
    @shell ||= Shell.new
  end

  class Script
    attr_accessor :shell, :name

    def initialize(&block)
      @shell = Scripts.shell

      instance_eval(&block)
    end

    def level_name(n)
      @name = name
    end

    def next_cmds
      @shell.run(forever=false) do |res, cmds|
        @latest_cmds = cmds
        @latest_res = res
      end
    end

    def output(text)
      puts text unless text.nil?
    end

    def expect_cmd(cmd, txt=nil)
      output(txt)
      next_cmds until latest_is? cmd
      yield
    end

    def latest_is?(cmd)
      unless @latest_cmds.nil?
        @latest_cmds.map { |c| c[:cmd] }.include? cmd.to_sym
      end
    end

    def run_playground(txt=nil)
      output(txt)
      @shell.run(forever=true)
    end
  end
end
