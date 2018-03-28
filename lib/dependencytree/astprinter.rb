require "dependencytree/version"
require 'pp'

module Dependencytree
  class ASTPrinter
    def initialize(path, tree)
      @path = path
      @tree = tree
    end

    def visit()
      pp @tree
    end
  end
end

