module Commands
  AVAILABLE_COMMANDS = [:exit, :ls, :cd, :help, :time, :echo]
  STDOUT = :stdout
  STDIN = :stdin

  def self.exit(args, input=STDIN)
    abort
  end

  def self.help(args, input=STDIN)
    data  = "Available commands:\n#{AVAILABLE_COMMANDS.join("\n")}"
    pipe_out(data, out)
  end

  def self.ls(args, input=STDIN)
  end

  def self.cd(args, input=STDIN)
  end

  def self.time(args, input=STDIN)
    Time.now()
  end

  def self.echo(args, input=STDIN)
    if args.length > 0
      data = args.join(" ")
    else
      data = pipe_in(input)
    end
    data
  end

  private

  def self.pipe_in(input)
    if input == STDIN
      gets
    else
      input
    end
  end
end
