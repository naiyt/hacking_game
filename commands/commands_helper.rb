require 'pry'
require 'singleton'

module Commands
  AVAILABLE_COMMANDS = [:exit, :ls, :cd, :help, :time, :echo, :grep, :pwd, :mkdir, :history]
  STDOUT = :stdout
  STDIN = :stdin

  class CommandRunner
    include Singleton
    attr_reader :input, :args
    attr_accessor :shell

    def initialize
      @input = STDIN
      @commands = {}
    end

    def execute(cmd_sym, args, input)
      @commands[cmd_sym] ||= klass(cmd_sym).new
      @input = input
      @args = args
      @commands[cmd_sym].run
    end

    # http://stackoverflow.com/a/5924541/1026980
    def klass(cmd_sym)
      "Commands::#{cmd_sym.capitalize}".split('::').inject(Object) {|o,c| o.const_get c}
    end
  end

  class NotImplemented < StandardError
  end

  class Command
    def initialize
      @runner = CommandRunner.instance
    end

    def from_stdin?
      @runner.input == STDIN
    end

    def get_input
      if from_stdin?
        gets
      else
        @runner.input
      end
    end

    def args
      @runner.args
    end

    def fs
      Filesystem::Filesystem.instance
    end

    def run
      raise NotImplemented 'You must implement a run method in your command'
    end
  end

  Dir['commands/lib/*.rb'].each { |file| require File.expand_path file }
end
