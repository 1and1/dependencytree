require "dependencytree/version"
require 'parser/current'
require "dependencytree/classmodel"

module Dependencytree
  class DependencyAggregator
    def initialize()
      # path will be the file system path of the source file
      @path = nil
      # context_stack is the stack of modules/classes loaded (namespacing)
      @context_stack = []
      # this is a flat list of all classes / modules seen
      @classes = []

      @debug = false
      _handle_class_module_common(:module, "Kernel", nil)
      @kernel = _resolve("Kernel")
    end

    def top_of_stack
      if @context_stack.empty?
        @kernel
      else
        @context_stack[-1]
      end
    end

    def to_json
      @classes.to_json
    end

    # Make an array of strings out of a encapsulated tree of :const expressions.
    # @param node the top const node to start flattening at.
    def flatten_const_tree(node)
      raise ArgumentError, "type needs to be const (#{node.type})" if node.type != :const
      raise ArgumentError, "Children count needs to be 2 (#{node.children.length})" if node.children.length != 2

      result = node.children[1..1]
      if node.children[0] && node.children[0].type == :const
        result = flatten_const_tree(node.children[0]) + result
      end
      result
    end

    # Finds a class or module by its full name.
    # @param full_name the full name.
    def _resolve(full_name)
      @classes.find  { |clazz| clazz.get_full_name() == full_name }
    end

    # Handle a const expression.
    # @param node the const node itself to handle.
    def _const(node)
      puts "const" if @debug
      pp node if @debug

      raise ArgumentError, "type needs to be const (#{node.type})" if node.type != :const
      raise ArgumentError, "Children count needs to be 2 (#{node.children.length})" if node.children.length != 2

      reference = flatten_const_tree(node)
      top_of_stack().add_reference(reference)
      puts "added #{reference}" if @debug
    end

    # Handle a module expression.
    # @param node the module node itself to handle.
    def _module(node)
      raise ArgumentError, "Children count for module is != 2 (#{node.children.length})" if node.children.length != 2
      raise ArgumentError, "First module child needs to be a const (#{node.children[0].type} #{node.children[0].type})" if node.children[0].type != :const

      puts "module #{node.children[0].children[1]}" if @debug

      current_module_name = node.children[0].children[1]
      _handle_class_module_common(:module, current_module_name, node)
    end

    # Handle a class expression.
    # @param node the class node itself to handle.
    def _class(node)    
      raise ArgumentError, "Children count for class is != 3 (#{node.children.length})" if node.children.length != 3
      raise ArgumentError, "First class child needs to be a const (#{node.children[0].type} #{node.children[0].type})" if node.children[0].type != :const
      puts "clazz #{node.children[0].children[1]}" if @debug

      current_class_name = node.children[0].children[1]
      _handle_class_module_common(:class, current_class_name, node)
    end

    # Handle the common parts of a module or class definition. Will try to resolve the instance or create it if not found.
    # @param type :module or :class.
    # @param name the local class name.
    # @param node the AST node of the class or module, can be nil if no children traversal required.
    def _handle_class_module_common(type, name, node)
      if @parent
        resolved = _resolve(@parent.get_full_name()+"::"+name)
      else
        resolved = _resolve(name)
      end
      if ! resolved.nil?
        # found an existing module/class with the full_name
        model = resolved
      else
        # found no existing module/class with the full_name
        model = ClassModel.new(type, @path, name)
        @classes <<= model 
      end
      if ! @context_stack.empty?
        model.set_parent(@context_stack[-1])
      end

      @context_stack <<= model
      # recurse over the contents of the module
      visit_children(node.children[1..node.children.length]) if node
      @context_stack.pop
    end

    # Handle a def expression.
    # @param node the def node itself to handle.
    def _def(node)
      raise ArgumentError, "Children count for def is != 3 (#{node.children.length})" if node.children.length != 3

      puts "def #{node.children[0]}" if @debug

      # depending on whether in module or class be clever here ;)
      top_of_stack().add_method(node.children[0])

      visit_children(node.children[1..node.children.length])
    end

    # Visit a AST node and do the appropriate actions.
    # @param node the node to visit.
    def visit_node(node)
      if node.type() == :const
        _const(node)
      elsif node.type() == :class
        _class(node)
      elsif node.type() == :module
        _module(node)
      elsif node.type() == :def
        _def(node)
      else
        visit_children(node.children)
      end
    end

    # Visit all children of a node. Will call #visit_note on each node child.
    # @param children the array of children to visit.
    def visit_children(children)
      return if ! children
      children.each { |child|
        if child.respond_to?(:children)
          visit_node(child)
        end
      }
    end

    # Visits all children of the AST tree.
    # @param path the filesystem path of the parsed entity (ruby file).
    # @param tree the AST tree node.
    def visit(path, tree)
      begin
        pp tree if @debug
        @path = path
        visit_node tree
        @path = nil
      rescue Exception => e
        puts "Error in path #{path}"
        raise e
      end
    end
  end
end

