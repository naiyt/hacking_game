require 'yaml'
require 'shell_sim'

ShellSim.configure do |config|
  config.fs_data    = YAML.load_file('config/fs.yml')
  config.users_data = YAML.load_file('config/passwd.yml')
end

