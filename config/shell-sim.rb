require 'yaml'
require 'shell-sim'

ShellSim.configure do |config|
  config.fs_data    = YAML.load_file('config/fs.yml')
  config.users_data = YAML.load_file('config/passwd.yml')
end

