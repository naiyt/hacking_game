require_relative 'config/shell_sim'
require 'optparse'
require 'pry'
require 'yaml'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: game.rb [level]"

  opts.on("-a", "--all", "Play the entire game") do |a|
    options[:all] = true
  end

  opts.on("-l", "--levels LEVELS", String, "Comma separated list of levels") do |levels|
    options[:levels] = levels.split(",")
  end
end.parse!

def get_class(cls_sym)
  cls_name = cls_sym.capitalize
  "ShellSim::Scripts::#{cls_name}".split("::").inject(Object) { |o,c| o.const_get c }
end

def load_level(level_name)
  load "#{File.dirname(__FILE__)}/levels/#{level_name}/#{level_name}.rb"
end

def get_levels(level_names)
  # Load specified levels (use standard of levels/leveln/leveln.rb)
  level_names.map { |level_title| load_level(level_title) }

  # Return the actual level classes
  level_names.map { |level| get_class(level.to_sym) }
end


if options[:all]
  level_names = Dir.entries("levels").reject { |dir| dir[0] == '.' }
else
  level_names = options[:levels]
end

levels = get_levels(level_names)
levels.each(&:play)

