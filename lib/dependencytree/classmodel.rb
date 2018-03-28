require "dependencytree/version"

module Dependencytree
  class ClassModel
    # path: the filesystem path the parsed class was found in
    # module_name: eventual module name or :anonymous
    # class_name: the class name
    def initialize(path, module_name, class_name)
      @path = path
      @module_name = module_name
      @class_name = class_name
      @method_names = []
      @references = []
    end

    def as_json(*a)
      {
        "path" => @path,
        "module" => @module_name,
        "class" => @class_name,
        "methods" => @method_names,
        "refs" => @references.uniq
      }
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

