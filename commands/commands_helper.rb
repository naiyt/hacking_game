require 'pry'
require 'singleton'
require_relative 'output_helper'
require_relative 'exceptions'

module Commands
  STDOUT = :stdout
  STDIN = :stdin

  def self.available_commands
    @available_commands || get_default_commands
  end

  def self.available_commands=(commands=available_commands)
    @available_commands = commands
  end

  def self.get_default_commands
    commands = Commands.constants.select do |c|
      constant = Commands.const_get(c)
      constant.is_a?(Class) && constant < Commands::Command
    end
    commands.map(&:downcase)
  end

  class CommandRunner
    include Singleton
    attr_reader :input, :args
    attr_accessor :shell

    def initialize
      @input = STDIN
      @commands = {}
    end

    def execute(cmd_sym, args, input)
      @commands[cmd_sym] ||= get_class(cmd_sym).new
      @input = input
      @args = args
      @commands[cmd_sym].run
    end

    # http://stackoverflow.com/a/5924541/1026980
    def get_class(cmd_sym)
      "Commands::#{cmd_sym.capitalize}".split('::').inject(Object) {|o,c| o.const_get c}
    end
  end

  class Command
    include Commands::OutputHelper

    def initialize
      @runner = CommandRunner.instance
    end

    def from_stdin?
      @runner.input == STDIN
    end

    def get_input
      from_stdin? ? gets : @runner.input
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

