require "dependencytree/version"
require "securerandom"

module Dependencytree

  # Model for classes and modules
  class ClassContainer

    # type: :class or :module
    # path: the filesystem path the parsed class was found in
    # module_name: eventual module name or :anonymous
    # class_name: the class name
    def initialize(classes_and_modules)
      @classes_and_modules = classes_and_modules

      resolve_references()
    end

    def resolve_references()
      @classes_and_modules.each do |clazz|
        $LOG.debug("Processing class #{clazz.full_name}")
        clazz.references.each do |ref_array|
          $LOG.debug("Resolving #{ref_array.to_s}")
          full_name = ref_array.join("::")
          $LOG.debug("Full name is #{full_name} #{full_name.class.name}")
          class_model = resolve_by_full_name(full_name)
          result = "NIL"
          result = class_model.uuid if class_model

          if class_model
           $LOG.debug("Resolved #{full_name} to uuid #{class_model.uuid}")
          else
           $LOG.debug("Could not resolve #{full_name}")
          end
        end
      end
    end

    # Finds a class or module by its full name.
    # @param full_name the full name to search for.
    def resolve_by_full_name(full_name)
      @classes_and_modules.find  { |clazz| clazz.full_name() == full_name }
    end

    # Finds a class or module by its local name.
    # @param name the name to search for.
    def resolve_by_name(name)
      @classes_and_modules.find  { |clazz| clazz.name == name }
    end
  end
end

