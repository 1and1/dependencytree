require "dependencytree/version"
require 'parser/current'

module Dependencytree
  class DependencyAggregator
    def initialize(path, tree)
      @path = path
      @tree = tree
      @references = {}
      @current_class = :anonymous
    end

    def to_json
      @references.to_json
    end

    def const(node)
      puts "const"
      pp node

      raise ArgumentError, "type needs to be const (#{node.type})" if node.type != :const
      raise ArgumentError, "Children count needs to be 2 (#{node.children.length})" if node.children.length != 2

      if @current_class
        reference = node.children[1]
        @references[@current_class] = [] if ! @references[@current_class]
        @references[@current_class] << reference.to_sym
        puts "added #{reference}"
      end
    end

    def clazz(node)
      puts "clazz"
      
      raise ArgumentError, "Children count for class is != 2 (#{node.children.length})" if node.children.length != 3
      raise ArgumentError, "First class child needs to be a const (#{node.children[0].type} #{node.children[0].type})" if node.children[0].type != :const

      puts "clazz #{node.children[0].children[1]}"

      old_class = @current_class
      @current_class = node.children[0].children[1]
      @references[@current_class] = []
      visit_children(node)
      @current_class = node.children[0].children[1]
      @current_class = old_class
    end

    def visit_node(node)
      if node.type() == :const
        const(node)
      elsif node.type() == :class
        clazz(node)
      end
      node.children.each { |child|
        @json_node = {}
        if child.respond_to?(:children)
	  visit_node(child)
        end
      }
    end

    def visit_children(node)
      node.children.each { |child|
        @json_node = {}
        if child.respond_to?(:children)
	  visit_node(child)
        end
      }
    end

    def visit()
      visit_node @tree
    end
  end
end

