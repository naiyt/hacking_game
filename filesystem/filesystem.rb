require 'singleton'
require 'yaml'

module Filesystem
  class Filesystem
    include Singleton
    attr_reader :pwd

    def initialize
      default_fs = YAML.load_file './filesystem/default_fs.yaml'
      @root = Directory.new('root')
      add_all_defaults(default_fs['root'], @root)
      @pwd = @root
    end

    def add_all_defaults(directories, current_parent)
      directories.each do |directory|
        if directory.is_a? String
          current_parent.add_child(directory)
        elsif directory.is_a? Hash
          nested_parent = current_parent.add_child(directory.keys[0])
          add_all_defaults(directory.values.flatten, nested_parent)
        end
      end
    end

    def cd(directory)
      if @pwd.has_directory? directory
        @pwd = @pwd.children[directory]
      else
        puts "#{directory} does not exist"
      end
    end
  end

  class AlreadyExistsError < StandardError
  end

  class Directory
    attr_accessor :name
    attr_reader :parent, :children

    def initialize(name, parent=nil, children={})
      @name = name
      @parent = parent
      @children = children
    end

    def add_child(name)
      if @children.has_key?(name)
        raise AlreadyExistsError, "A file or directory called #{name} already exists"
      else
        child = Directory.new(name, self)
        @children[child.name] = child
      end
    end

    def ls
      @children.keys.join '  '
    end

    def has_directory?(directory)
      @children.keys.include? directory
    end

    def path_to
      dirs = [@name]
      curr = self
      until curr.parent.nil?
        curr = curr.parent
        dirs << curr.name
      end
      dirs = dirs.reverse[1..-1] # Don't include "root"
      '/' + dirs.join('/')
    end
  end

  class File
  end
end
