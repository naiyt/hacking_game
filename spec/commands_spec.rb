require 'spec_helper'

describe 'commands' do
  before do
    @shell = Shell.new
  end

  def exec(cmd)
    @shell.exec_cmds(@shell.format_input(cmd))
  end

  def mock_stdout(cmd, output)
    if output.nil?
      expect(STDOUT).not_to receive(:puts)
    else
      expect(STDOUT).to receive(:puts).with(output)
    end
    exec(cmd)
  end

  describe 'cd and pwd' do
    before do
      exec('cd /')
      mock_stdout('pwd', '/')
    end

    it 'works with relative paths' do
      exec('cd usr')
      mock_stdout('pwd', '/usr')
    end

    it 'works with absolute paths' do
      exec('cd /usr/bin')
      mock_stdout('pwd', '/usr/bin')
    end

    it 'does not send stdout' do
      mock_stdout('cd usr', nil)
    end

    it 'prints a warning message if CDing into a non-existant directory' do
      mock_stdout('cd blah', 'blah does not exist')
    end

    it 'does nothing if you use no args' do
      exec('cd')
      mock_stdout('pwd', '/')
    end

    it 'works with . and ..' do
      exec('cd usr')
      mock_stdout('pwd', '/usr')
      exec('cd ..')
      mock_stdout('pwd', '/')
      exec('cd /usr')
      exec('cd .')
      mock_stdout('pwd', '/usr')
    end
  end

  describe 'echo' do
    it 'simply prints args to stdout' do
      mock_stdout('echo blah', 'blah')
    end

    it 'accepts stdin from other commands and prints to stdout' do
      time = Time.now
      double(:Time => time)
      mock_stdout('time | echo', time.to_s)
    end
  end

  describe 'grep' do
    it 'will search the input from STDIN and print matching results to STDOUT' do
      mock_stdout('echo blah | grep blah', 'blah')
      mock_stdout('echo do not match | grep "cool face"', nil)
    end
  end

  describe 'ls' do
    before do
      exec('cd /')
    end

    context 'no args' do
      it 'will list the contents of the present working directory' do
        mock_stdout('ls', 'tmp   usr   etc   home')
      end
    end

    context 'with args' do
      it 'works with both a relative and absolute path' do
        mock_stdout('ls usr/', 'bin')
        mock_stdout('ls /usr/bin', '')
      end
    end

    it 'will list hidden directories if you pass the -a arg' do
      exec('cd tmp')
      mock_stdout('ls -a', '.   ..')
    end
  end

  describe 'pwd' do
    it 'will list the full path of the present working directory' do
      exec('cd /')
      mock_stdout('pwd', '/')
      exec('cd /usr')
      mock_stdout('pwd', '/usr')
      exec('cd bin/')
      mock_stdout('pwd', '/usr/bin')
    end
  end

  describe 'mkdir' do
    it 'will make a new directory' do
      exec('cd /')
      mock_stdout('ls', 'tmp   usr   etc   home')
      exec('mkdir newdir')
      mock_stdout('ls', 'tmp   usr   etc   home   newdir')
    end

    it 'works with absolute paths' do
      exec('mkdir /usr/bin/coolface')
      mock_stdout('ls usr/bin', 'coolface')
    end

    it 'works with relative paths' do
      exec('mkdir /tmp/tempdir')
      mock_stdout('ls tmp', 'tempdir')
    end

    it 'prints an error message if you try to make a subdir of a file' do
      exec('touch coolfile')
      mock_stdout('mkdir coolfile/foo', 'coolfile is a file')
    end
  end

  describe 'rmdir' do
    it 'will delete a directory if it is empty' do
      exec('rmdir home')
      mock_stdout('ls', 'tmp   usr   etc   newdir   coolfile')
    end

    it 'will not delete a directory if it is not empty' do
      mock_stdout('rmdir usr', 'rmdir: usr is not empty')
    end

    it 'will print a message if the directory does not exist' do
      mock_stdout('rmdir blah', 'rmdir: blah does not exist')
    end
  end

  describe 'touch' do
    it 'will create an empty file if the file does not exist' do
      exec('touch blah')
      mock_stdout('ls', 'tmp   usr   etc   newdir   coolfile   blah')
    end

    it 'will update the timestamp if the file or dir does exist' do
      pending 'Implement timestamps'
      this_should_not_get_executed
    end

    it 'will print a warning message if the path is invalid' do
      mock_stdout('touch /bad/paths/are/bad', 'path does not exist')
    end

    it 'will print a warning message if trying to add a child of a file' do
      exec('touch fds')
      mock_stdout('touch fds/blah', 'fds is a file')
    end
  end

  describe 'filetype' do
    it 'will return the correct filetype' do
      mock_stdout('filetype etc', 'Directory')
      mock_stdout('filetype blah', 'File')
    end
  end

  describe 'man' do
    it 'will return the manual as defined by the class' do
      mock_stdout('man man', Commands::Man.manual)
    end

    it 'will return an error if the command does not exist' do
      mock_stdout('man dfdsfds', 'Command not found: dfdsfds')
    end

    it 'will return an error if the command has no manual' do
      mock_stdout('man ls', 'ls: no manual found')
    end
  end
end
