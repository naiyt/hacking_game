require 'yaml'
require 'shell_sim'

ShellSim.configure do |config|
  config.fs_data    = YAML.load_file('config/default_fs.yml')
  config.users_data = YAML.load_file('config/default_users.yml')
end

