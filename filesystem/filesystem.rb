require 'singleton'
require 'yaml'

module Filesystem
  class AlreadyExistsError < StandardError
  end

  class FileDoesNotExistError < StandardError
  end

  class DirectoryNotEmptyError < StandardError
  end

  class FileAlreadyExists < StandardError
  end

  class PathDoesNotExist < StandardError
  end

  class FileNotDir < StandardError
  end

  class Table
    include Singleton
    attr_accessor :table

    def initialize
      @table = {}
    end
  end

  class Filesystem
    include Singleton
    attr_reader :pwd

    def initialize
      reinit
    end

    def reinit
      default_fs = YAML.load_file './filesystem/default_fs.yaml'
      @root = Directory.new('root')
      @pwd = @root
      Table.instance.table = {}
      add_all_defaults(default_fs['root'], @root)
    end

    def add_all_defaults(directories, current_parent)
      directories.each do |directory|
        if directory.is_a? String
          mkdir(directory, current_parent)
        elsif directory.is_a? Hash
          nested_parent = mkdir(directory.keys[0], current_parent)
          add_all_defaults(directory.values.flatten, nested_parent)
        end
      end
    end

    def cd(directory)
      dir = Table.instance.table[get_abs_path(directory)]
      raise FileDoesNotExistError if dir.nil?
      @pwd = dir
    end

    def ls_path(path)
      dir_or_file = Table.instance.table[get_abs_path(path)]
      raise FileDoesNotExistError if dir_or_file.nil?
      dir_or_file.ls
    end

    def mkdir(name, specified_parent=nil)
      if specified_parent.nil?
        parent, dir_name = get_parent(name)
        parent.add_child(dir_name, Directory)
      else
        specified_parent.add_child(name, Directory)
      end
    end

    def rmdir(name, parent=@pwd)
      dir = Table.instance.table[get_abs_path(name)]
      raise FileDoesNotExistError if dir.nil?
      raise DirectoryNotEmptyError if dir.has_children?
      parent.children.delete dir.name
      Table.instance.table.delete dir.path_to
    end

    def create_file(path, data=nil)
      raise FileAlreadyExists if something_here? path
      parent, file_name = get_parent(path)
      parent.add_child(file_name, File)
    end

    def file_type(path)
      file = Table.instance.table[get_abs_path(path)]
      raise FileDoesNotExistError if file.nil?
      file.class
    end

    private

    def something_here?(path)
      Table.instance.table.has_key? get_abs_path(path)
    end

    def get_parent(path)
      path = path.split("/")
      dir_name = path[-1]
      path = path[0..-2].join("/")
      parent = Table.instance.table[get_abs_path(path)]
      raise PathDoesNotExist if parent.nil?
      [parent, dir_name]
    end

    def get_abs_path(path)
      # TODO - clean this up a bit
      if abs_path?(path)
        return path
      elsif path == '..' || path == '.'
        if path == '..'
          raise FileDoesNotExistError if pwd.parent.nil?
          return pwd.parent.path_to
        elsif path == '.'
          return pwd.path_to
        end
      else
        path = pwd.path_to == '/' ? "/#{path}" : [pwd.path_to, path].join('/')
        path = path[0..-2] if path[-1] == '/' && path.length > 1
        return path
      end
    end

    def abs_path?(path)
      path ? path[0] == '/' : false
    end

    def relative_path?(path)
      !abs_path(path)
    end
  end

  module FileDirHelpers
    def path_to(recache=false)
      @path = nil if recache
      @path ||= get_path_to
      Table.instance.table[@path] = self
      @path
    end

    def get_path_to
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

  class Directory
    include FileDirHelpers

    attr_accessor :name
    attr_reader :parent, :children

    def initialize(name, parent=nil, children={})
      @name = name
      @parent = parent
      @children = children
      add_default_refs
      path_to(recache=true)
      Table.instance.table[path_to] = self
    end

    def add_child(name, klass)
      if @children.has_key?(name)
        raise AlreadyExistsError, "A file or directory called #{name} already exists"
      else
        @children[name] = klass.new(name, self)
      end
    end

    def ls
      @children.keys
    end

    def has_directory?(directory)
      @children.keys.include? directory
    end

    def has_children?
      @children.length > 2 # Don't count . and ..
    end

    private

    def add_default_refs
      @children['.'] = self
      @children['..'] = @parent unless @parent.nil?
    end
  end

  class File
    include FileDirHelpers

    attr_accessor :name
    attr_reader :parent

    def initialize(name, parent, data=nil)
      @name = name
      @parent = parent
      @data = data
      path_to(recache=true)
    end

    def add_child(*args)
      raise FileNotDir, "#{@name} is a file"
    end
  end
end
