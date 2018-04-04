require "dependencytree/version"
require "securerandom"

module Dependencytree

  # Model for classes and modules
  class ClassModel

    attr_reader :uuid
    attr_reader :name
    attr_reader :references

    # type: :class or :module
    # path: the filesystem path the parsed class was found in
    # module_name: eventual module name or :anonymous
    # class_name: the class name
    def initialize(type, path, name)
      # unique uuid for reference
      @uuid = SecureRandom.uuid
      # :module or :class
      @type = type
      # filesystem path of (first) definition
      @path = path
      # local name (without enclosing modules)
      @name = name
      # list of names of methods
      @method_names = []
      # list of names of constants
      @constant_names = []
      # list of (unresolved) references as arrays
      @references = []
    end

    # Gets the full name of the class/module as an array.
    # @return the full name, for example ["ModuleA","ModuleB","ClassA"]
    def full_name_array()
      if @parent
        result = @parent.full_name_array() << @name.to_s
      else
        result = [ @name.to_s ]
      end
      result
    end

    # Gets the full name of the class/module.
    # @return the full name, for example "ModuleA::ModuleB::ClassA"
    def full_name()
      full_name_array.join("::")
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
        "full_name" => full_name(),
        "methods" => @method_names,
        "constants" => @constant_names,
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
    def add_constant(constant_name)
      @constant_names <<= constant_name.to_sym
    end

    # Adds a method by its name to the list of methods.
    # TBD method attributes
    def add_reference(ref)
      @references <<= ref
    end
  end
end

