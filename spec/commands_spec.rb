require 'spec_helper'

describe 'commands' do
  let(:shell) { Shell.new }

  def exec(cmd)
    shell.exec_cmds(shell.format_input(cmd))
  end

  def mock_stdout(cmd, output)
    expect(STDOUT).to receive(:puts).with(output)
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
      expect(STDOUT).not_to receive(:puts)
      exec('cd usr')
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
end
