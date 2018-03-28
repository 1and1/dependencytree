require "dependencytree/version"
require 'parser/current'
require "dependencytree/classmodel"

module Dependencytree
  class DependencyAggregator
    def initialize()
      @path = nil
      @current_module_name = :anonymous
      @current_class_name = :anonymous
      @classes = []
    end

    def to_json
      @classes.to_json
    end

    def flatten_const_tree(node)
      raise ArgumentError, "type needs to be const (#{node.type})" if node.type != :const
      raise ArgumentError, "Children count needs to be 2 (#{node.children.length})" if node.children.length != 2

      result = node.children[1..1]
      if node.children[0] && node.children[0].type == :const
        result = flatten_const_tree(node.children[0]) + result
      end
      result
    end

    def const(node)
      puts "const"
      pp node

      raise ArgumentError, "type needs to be const (#{node.type})" if node.type != :const
      raise ArgumentError, "Children count needs to be 2 (#{node.children.length})" if node.children.length != 2

      if @current_class
        reference = flatten_const_tree(node)
        @current_class.add_reference(reference)
        puts "added #{reference}"
      end
    end

    def _module(node)
      raise ArgumentError, "Children count for module is != 2 (#{node.children.length})" if node.children.length != 2
      raise ArgumentError, "First module child needs to be a const (#{node.children[0].type} #{node.children[0].type})" if node.children[0].type != :const

      puts "module #{node.children[0].children[1]}"

      old_module = @current_class
      @current_module_name = node.children[0].children[1]
      # recurse over the contents of the module
      visit_children(node.children[1..node.children.length])
      @current_module_name = old_module
    end

    def _def(node)
      raise ArgumentError, "Children count for def is != 3 (#{node.children.length})" if node.children.length != 3

      puts "def #{node.children[0]}"

      # depending on whether in module or class be clever here ;)
      @current_class.add_method(node.children[0])

      visit_children(node.children[1..node.children.length])
    end

    def _class(node)    
      raise ArgumentError, "Children count for class is != 3 (#{node.children.length})" if node.children.length != 3
      raise ArgumentError, "First class child needs to be a const (#{node.children[0].type} #{node.children[0].type})" if node.children[0].type != :const

      puts "clazz #{node.children[0].children[1]}"

      old_class_name = @current_class_name
      old_class = @current_class

      @current_class_name = node.children[0].children[1]
      @current_class = ClassModel.new(@path, @current_module_name, @current_class_name)
      @classes <<= @current_class

      @references[@current_class_name] = []
      # recurse over the contents of the class
      visit_children(node.children[1..node.children.length])
      @current_class_name = old_class_name
      @current_class = old_class
    end

    def visit_node(node)
      if node.type() == :const
        const(node)
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

    def visit_children(children)
      return if ! children
      children.each { |child|
        if child.respond_to?(:children)
          visit_node(child)
        end
      }
    end

    def visit(path, tree)
      pp tree
      @path = path
      visit_node tree
      @path = nil
    end
  end
end

