require_relative 'scripting/scripting'
require 'optparse'

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
  "Scripts::#{cls_sym}".split("::").inject(Object) { |o,c| o.const_get c }
end

if options[:all]
  Scripts.play_game
else
  levels = options[:levels].map { |level| get_class(level.to_sym) }
  levels.each(&:play)
end

