require "dependencytree/version"
require "securerandom"

module Dependencytree

  # Resolves symbols within the passed-in class/module array.
  class DependencyResolver

    attr_reader :classes_and_modules

    # type: :class or :module
    # path: the filesystem path the parsed class was found in
    # module_name: eventual module name or :anonymous
    # class_name: the class name
    def initialize(log, classes_and_modules)
      # store logger
      @@log = log
      @classes_and_modules = classes_and_modules
      @by_full_name = @classes_and_modules.each_with_object({})  { |clazz, hash| hash[clazz.full_name()] = clazz }
    end

    # Goes thru all classes and tries to resolve the references.
    def resolve_references
      @classes_and_modules.each do |clazz|
        @@log.debug("Processing class #{clazz.full_name} located in #{clazz.path}")
        clazz.references.each do |reference_array|
          refered_class = resolve_reference(clazz, reference_array)
          if refered_class
            clazz.resolved_references << refered_class.uuid
          else
            clazz.unresolved_references << reference_array
          end
        end
      end
    end

    # Tries to resolve one reference either as a constant or a class/module reference.
    # @param referer_class_model the ClassModel where the reference is in.
    # @param reference_array the reference as in the source, can be absolute or relative to the referer class.  
    # @return the ClassModel refering to (also for constants!).
    def resolve_reference(referer_class_model, reference_array)
      refered_class_model = resolve_reference_direct(referer_class_model, reference_array)
      if ! refered_class_model
        refered_class_model = resolve_reference_as_constant(referer_class_model, reference_array)
      end

      if refered_class_model
        @@log.debug("Resolved #{reference_array.join('::')} to uuid #{refered_class_model.uuid}")
      else
        @@log.debug("Could not resolve #{reference_array.join('::')}")
      end
      refered_class_model
    end

    # Resolve a constant module/class reference.
    # @param referer_class_model the ClassModel where the reference is in.
    # @param reference_array the reference as in the source, can be absolute or relative to the referer class. The last
    # element of the array is the constant name.
    # @return the refered class model or nil
    def resolve_reference_as_constant(referer_class_model, reference_array)
      reference_part = reference_array[0..-2]
      constant_name = reference_array[-1]

      @@log.debug("Resolving reference array #{reference_array.to_s} as reference #{reference_part.to_s} and constant #{constant_name}")

      refered_class_model = nil

      # qualified (Foo::CONST) or unqualified (CONST) reference?

      # try to resolve absolute (Outer::Inner1::Inner2::CONST)
      if reference_part.length > 0
        @@log.debug("Trying to resolve absolute")
        refered_class_model = resolve_reference_direct(referer_class_model, reference_part)
      end

      # try to resolve relative (Inner1::Inner2::CONST)
      if !refered_class_model && reference_part.length > 0
        @@log.debug("Trying to resolve relative")
        current = referer_class_model
        while !refered_class_model && current
          full_name_array = current.full_name_array
          if full_name_array.last(reference_part.length) == reference_part
            refered_class_model = current
            break
          end
          current = current.parent
        end
      end

      # try to resolve unqualified (CONST)
      if !refered_class_model && reference_part.length == 0
        @@log.debug("Trying to resolve unqualified")
        current_class = referer_class_model
        i = 0
        while (current_class) && (!refered_class_model) do
          @@log.debug("Current class #{i} is #{current_class.full_name}")

          refered_class_model = current_class if current_class.constant_names.include?(constant_name)

          current_class = current_class.parent
          i += 1
        end
      end

      if refered_class_model
        @@log.debug("Found reference to possible parent #{reference_part.to_s}")
        if refered_class_model.constant_names.include? constant_name.to_sym
          @@log.debug("Found class #{refered_class_model.full_name} constant #{constant_name}")
          refered_class_model
        else
          @@log.debug("Found class #{refered_class_model.full_name}, but not constant #{constant_name}. Known constants: #{refered_class_model.constant_names}")
          nil
        end
      else
        @@log.warn("No refered class model for #{reference_part.to_s}")
        nil
      end
    end

    # Resolve a full module/class reference.
    # @param referer_class_model the ClassModel where the reference is in.
    # @param reference_array the reference as in the source, can be absolute or relative to the referer class.
    # @return the refered class model or nil
    def resolve_reference_direct(referer_class_model, reference_array)
      @@log.debug("Resolving reference array #{reference_array.to_s}")

      referer_array = referer_class_model.full_name_array
      i = 0
      refered_class_model = nil
      while !refered_class_model do
        @@log.debug("Referer array #{i} is #{referer_array.to_s}")
        full_name = (referer_array+reference_array).join("::")
        @@log.debug("Full name #{i} is #{full_name} #{full_name.class.name}")
        refered_class_model = resolve_by_full_name(full_name)

        break if referer_array.empty?
        referer_array = referer_array[0..-2]
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

