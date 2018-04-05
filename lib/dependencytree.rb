require "dependencytree/dependencyaggregator"
require "dependencytree/classcontainer"

require "dependencytree/version"
require 'parser/current'
require 'optparse'
require 'pp'
require 'json'
require 'logger'

module Dependencytree

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
      LOG.debug("Handling path #{path}")
      tree = Parser::CurrentRuby.parse_file(path)
      LOG.debug("Parsed tree: #{tree}") if LOG.debug?
      consumer.visit(path, tree)
    end
  end

  LOG = Logger.new('application.log', 'daily', 20)

  options = {}
  options[:ignore] = /^$/
  options[:pattern] = /.*\.rb/
  OptionParser.new do |opt|
    opt.on("-v", "--verbose", "Verbose output") do |o|
      options[:verbose] = true
      LOG.debug("verbose")
    end
    opt.on("-p", "--pattern[=OPTIONAL]", "Pattern to accept source codes with (default: #{options[:pattern].to_s})") do |o|
      options[:pattern] = /#{o}/
      LOG.debug("pattern = #{o}")
    end
    opt.on("-i", "--ignore[=OPTIONAL]", "Paths to not load (default: #{options[:ignore].to_s})") do |o|
      options[:ignore] = /#{o}/
      LOG.debug("ignore = #{o}")
    end
    opt.on("-o", "--output[=OPTIONAL]", "Output path for the JSON file") do |o|
      options[:output] = o
      LOG.debug("output = #{o}")
    end
    opt.on_tail("-h", "--help", "Show this message") do
      puts opt
      exit
    end
  end.parse!

  consumer = DependencyAggregator.new
  ARGV.each do |path|
    handle_path(options, consumer, File.absolute_path(path))
  end

  classcontainer = ClassContainer.new(consumer.classes_and_modules)
  classcontainer.resolve_references

  json = classcontainer.classes_and_modules.to_json
  if options[:output]
    File.write(options[:output], json)
  else
    puts json
  end
end

