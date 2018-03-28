require "dependencytree/astprinter"
require "dependencytree/dependencyaggregator"

require "dependencytree/version"
require 'parser/current'
require 'optparse'
require 'pp'
require 'json'

module Dependencytree

  options = {}
  OptionParser.new do |opt|
    opt.on("-v", "--verbose", "Verbose output") { |o| options[:verbose] = true }
    opt.on_tail("-h", "--help", "Show this message") do
      puts opt
      exit
    end
  end.parse!

  ARGV.each { |path|
    puts "path" if options[:verbose]
    tree = Parser::CurrentRuby.parse_file(path)
#    printer = ASTPrinter.new(path, tree)
    printer = DependencyAggregator.new(path, tree)
    printer.visit
    puts printer.to_json
  }

end

