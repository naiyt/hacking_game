require 'yaml'
require 'shell_sim'

Dir["#{File.dirname(__FILE__)}/../levels/**/*.rb"].each { |f| load(f) }

ShellSim.configure do |config|
  config.fs_data    = YAML.load_file('config/default_fs.yml')
  config.users_data = YAML.load_file('config/default_users.yml')
end

