require "dependencytree/version"
require "securerandom"

module Dependencytree
  class ClassModel

    attr_reader :uuid

    # type: :class or :module
    # path: the filesystem path the parsed class was found in
    # module_name: eventual module name or :anonymous
    # class_name: the class name
    def initialize(type, path, name)
      @uuid = SecureRandom.uuid
      @type = type
      @path = path
      @name = name
      @method_names = []
      @references = []
    end

    def get_full_name()
      if @parent
        result = @parent.get_full_name().to_s + "::" + @name.to_s
      else
        result = @name
      end
      result
    end

    def set_parent(parent)
      raise ArgumentError, "Self parent reference for name #{@name}" if parent == self
      @parent = parent
    end

    def as_json(*a)
      result = {
        "uuid" => @uuid,
        "type" => @type,
        "path" => @path,
        "name" => @name,
        "full_name" => get_full_name(),
        "methods" => @method_names,
        "refs" => @references.uniq
      }

      if @parent
        result["parent_uuid"] = @parent.uuid
      end
      result
    end

    def to_json(*a)
        as_json.to_json(*a)
    end

    # Adds a method by its name to the list of methods.
    # TBD method attributes
    def add_method(method_name)
      @method_names <<= method_name.to_sym
    end

    # Adds a method by its name to the list of methods.
    # TBD method attributes
    def add_reference(ref)
      @references <<= ref
    end
  end
end
