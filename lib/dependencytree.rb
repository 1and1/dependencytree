require "dependencytree/astprinter"
require "dependencytree/dependencyaggregator"

require "dependencytree/version"
require 'parser/current'
require 'optparse'
require 'pp'
require 'json'

module Dependencytree

  def self.handle_path(options, consumer, path)
    if options[:ignore].match(path)
      return
    end
    if File.directory?(path)
      Dir.entries(path).each { |x|
        resolved = File.join(path, x)
        handle_path(options, consumer, resolved) if File.directory?(resolved) && x != "." && x != ".."
        handle_path(options, consumer, resolved) if File.file?(resolved) && options[:pattern].match(resolved)
      }
    elsif File.file?(path)
      tree = Parser::CurrentRuby.parse_file(path)
      consumer.visit(path, tree)
    end
  end

  options = {}
  options[:ignore] = Regexp.new("^$")
  options[:pattern] = Regexp.new(".*\\.rb")
  OptionParser.new do |opt|
    opt.on("-v", "--verbose", "Verbose output") { |o| options[:verbose] = true }
    opt.on("-p", "--pattern[=OPTIONAL]", "Pattern to accept source codes with (default: #{options[:pattern].to_s})") do |o|
      options[:pattern] = Regexp.new(o)
    end
    opt.on("-i", "--ignore[=OPTIONAL]", "Paths to not load (default: #{options[:ignore].to_s})") do |o|
      options[:ignore] = Regexp.new(o)
    end
    opt.on_tail("-h", "--help", "Show this message") do
      puts opt
      exit
    end
  end.parse!

  consumer = DependencyAggregator.new()
  ARGV.each do |path|
    puts "Path #{path}" if options[:verbose]
    handle_path(options, consumer, File.absolute_path(path))
  end
  puts consumer.to_json

end

