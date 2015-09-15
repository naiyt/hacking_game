require_relative 'shell/shell'

debug = false

shell = Shell.new('nate', 'password', debug=debug)
shell.run
