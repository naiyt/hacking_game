require 'rspec'
require_relative '../commands/commands_helper'
require_relative '../filesystem/filesystem'

describe 'commands' do
  let(:runner) { Commands::CommandRunner.instance }
  let(:fs) { Filesystem::Filesystem.instance }

  describe 'cd' do
    before do
      runner.execute(:cd, ['/'], nil)
      expect(fs.pwd.path_to).to eq('/')
    end

    it 'works with relative paths' do
      expect{runner.execute(:cd, ['usr'], nil)}.to change{fs.pwd.path_to}.from('/').to('/usr')
    end

    it 'works with absolute paths' do
      expect{runner.execute(:cd, ['/usr/bin'], nil)}.to change{fs.pwd.path_to}.from('/').to('/usr/bin')
    end

    it 'does not send stdout' do
      expect(runner.execute(:cd, ['usr'], nil)).to be_nil
    end

    it 'prints a warning message if CDing into a non-existant directory' do
      expect(runner.execute(:cd, ['fakfljd'], nil)).to eq 'fakfljd does not exist'
    end

    it 'does nothing if you use no args' do
      expect{runner.execute(:cd, [''], nil)}.not_to change{fs.pwd.path_to}
    end

    it 'works with . and ..' do
      runner.execute(:cd, ['/usr'], nil)
      expect(fs.pwd.path_to).to eq('/usr')
      expect{runner.execute(:cd, ['..'], nil)}.to change{fs.pwd.path_to}.from('/usr').to('/')
      expect{runner.execute(:cd, ['.'], nil)}.not_to change{fs.pwd.path_to}
    end
  end
end
