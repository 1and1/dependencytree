require "dependencytree/treeinterpreter"
require "dependencytree/dependencyresolver"

require "dependencytree/version"
require 'parser/current'
require 'optparse'
require 'pp'
require 'json'
require 'logger'

module Dependencytree

  # Contains the main method for handling the program flow.
  class TreeMain
    def self.handle_path(options, consumer, path)
      if options[:ignore].match(path)
        return
      end
      if File.directory?(path)
        STDERR.puts path if options[:verbose]
        Dir.entries(path).each { |x|
          resolved = File.join(path, x)
          handle_path(options, consumer, resolved) if File.directory?(resolved) && x != "." && x != ".."
          handle_path(options, consumer, resolved) if File.file?(resolved) && options[:pattern].match(resolved)
        }
      elsif File.file?(path)
        STDERR.puts path if options[:verbose]
        @@log.debug("Handling path #{path}")
        tree = Parser::CurrentRuby.parse_file(path)
        @@log.debug("Parsed tree: #{tree}") if LOG.debug?
        consumer.visit(path, tree)
      end
    end

    def self.main
      options = {}
      options[:ignore] = /^$/
      options[:pattern] = /.*\.rb/
      OptionParser.new do |opt|
        opt.on("-v", "--verbose", "Verbose output") do |o|
          options[:verbose] = true
        end
        opt.on("-d", "--debug", "Log debugging output to file 'dependencytree.log'") do |o|
          options[:debug] = true
        end
        opt.on("-p", "--pattern[=OPTIONAL]", "Pattern to accept source codes with (default: #{options[:pattern].to_s})") do |o|
          options[:pattern] = /#{o}/
        end
        opt.on("-i", "--ignore[=OPTIONAL]", "Paths to not load (default: #{options[:ignore].to_s})") do |o|
          options[:ignore] = /#{o}/
        end
        opt.on("-o", "--output[=OPTIONAL]", "Output path for the JSON file") do |o|
          options[:output] = o
        end
        opt.on_tail("-h", "--help", "Show this message") do
          puts opt
          exit
        end
      end.parse!

      if options[:debug]
        log = Logger.new('dependencytree.log')
        log.level = Logger::WARN
      else
        log = Logger.new(STDOUT)
        log.level = Logger::WARN
      end
      @@log = log

      treeinterpreter = TreeInterpreter.new(log)
      ARGV.each do |path|
        handle_path(options, treeinterpreter, File.absolute_path(path))
      end

      dependencyresolver = DependencyResolver.new(log, treeinterpreter.classes_and_modules)
      dependencyresolver.resolve_references

      json = dependencyresolver.classes_and_modules.to_json
      if options[:output]
        File.write(options[:output], json)
      else
        puts json
      end
    end
  end
end

