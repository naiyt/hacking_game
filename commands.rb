module Commands
  AVAILABLE_COMMANDS = [:exit, :ls, :cd, :help]

  def self.exit
    abort
  end

  def self.help
    puts "Available commands:"
    AVAILABLE_COMMANDS.each { |cmd| puts cmd }
  end

  def self.ls
  end

  def self.cd
  end
end
