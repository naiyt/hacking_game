require 'spec_helper'

describe 'commands' do
  let!(:shell) { Shell.new }

  def exec(cmd)
    shell.exec_cmds(shell.format_input(cmd))
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
  end
end
