module Commands
  AVAILABLE_COMMANDS = [:exit, :ls, :cd, :help, :time, :echo]
  STDOUT = :stdout
  STDIN = :stdin

  def self.exit
    abort
  end

  def self.help(out=STDOUT)
    data  = "Available commands:\n#{AVAILABLE_COMMANDS.join("\n")}"
    pipe_out(data, out)
  end

  def self.ls(out=STDOUT)
  end

  def self.cd(out=STDOUT)
  end

  def self.time(out=STDOUT)
    Time.now()
  end

  def self.echo(data='', input=STDIN, out=STDOUT)
    pipe_out(data, out)
  end

  private

  def self.pipe_out(data, out)
    if out == STDOUT
      stdout(data)
    else
      out.call(data)
    end
  end

  def self.stdout(output)
    puts output
  end
end
