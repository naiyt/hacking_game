module Filesystem

  class AlreadyExists < StandardError
  end

  class Directory
    attr_accessor :name
    attr_reader :parent

    def initialize(name, parent=nil, children={})
      @name = name
      @parent = parent
      @children = children
    end

    def add_child(name)
      if @children.has_key?(name)
        raise AlreadyExists "A file or directory called #{name} already exists"
      else
        child = Filesystem::Directory.new(name, self)
        @children[child.name] = child
      end
    end

    def ls
      @children.keys.join '  '
    end
  end

  class File
  end
end
