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
      @by_full_name = {}

      @classes_and_modules.each  { |clazz| @by_full_name[clazz.full_name()] = clazz }

      resolve_references()
    end

    def resolve_references()
      @classes_and_modules.each do |clazz|
        $LOG.debug("Processing class #{clazz.full_name} located in #{clazz.path}")
        clazz.references.each do |reference_array|
          resolve_reference(clazz, reference_array)
        end
      end
    end

    def resolve_reference(referer_class_model, reference_array)
      refered_class_model = resolve_reference_direct(referer_class_model, reference_array)
      if ! refered_class_model
        refered_class_model = resolve_reference_as_constant(referer_class_model, reference_array)
      end

      if refered_class_model
        $LOG.debug("Resolved #{reference_array.join('::')} to uuid #{refered_class_model.uuid}")
        refered_class_model
      else
        $LOG.debug("Could not resolve #{reference_array.join('::')}")
        nil
      end
    end


    def resolve_reference_as_constant(referer_class_model, reference_array)
      reference_part = reference_array[0..-2]
      constant_name = reference_array[-1]

      $LOG.debug("Resolving reference array #{reference_array.to_s} as reference #{reference_part.to_s} and constant #{constant_name}")

      refered_class_model = resolve_reference_direct(referer_class_model, reference_part)
      if refered_class_model
        $LOG.debug("Found reference to possible parent #{reference_part.to_s}")
        if refered_class_model.constant_names.find { |x| constant_name.to_s == constant_name.to_s }
          $LOG.debug("Found class #{refered_class_model.full_name} constant #{constant_name}")
          refered_class_model
        else
          $LOG.debug("Found class #{refered_class_model.full_name}, but not constant #{constant_name}. Known constants: #{refered_class_model.constant_names}")
          nil
        end
      else
        nil
      end
    end

    def resolve_reference_direct(referer_class_model, reference_array)
      $LOG.debug("Resolving reference array #{reference_array.to_s}")

      referer_array = referer_class_model.full_name_array()
      i = 0
      refered_class_model = nil
      while !(refered_class_model) do
        $LOG.debug("Referer array #{i} is #{referer_array.to_s}")
        full_name = (referer_array+reference_array).join("::")
        $LOG.debug("Full name #{i} is #{full_name} #{full_name.class.name}")
        refered_class_model = resolve_by_full_name(full_name)

        break if referer_array.empty?
        referer_array = referer_array.slice(0, referer_array.length - 1)
        i += 1
      end

      refered_class_model
    end

    # Finds a class or module by its full name.
    # @param full_name the full name to search for.
    def resolve_by_full_name(full_name)
      @by_full_name[full_name]
    end

    # Finds a class or module by its local name.
    # @param name the name to search for.
    def resolve_by_name(name)
      @classes_and_modules.find  { |clazz| clazz.name == name }
    end
  end
end

