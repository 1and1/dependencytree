require "dependencytree/treemain"
require "dependencytree/classmodel"

require "int_generator"

require 'minitest/autorun'
require "tempfile"
require "json"

# Test for parsing "one_module.rb" and comparing the output json.
class TestCommon < Minitest::Test

  # Call one programm and return the output JSON as a pre-parsed
  # Ruby hash.
  def self.call(classes)
    Dependencytree::ClassModel.generator = IntGenerator.new
    output = Tempfile.new("json")
    # * output to file
    # * debug
    # * the class files passed as parameter
    ARGV[0..-1] = ["-o#{output.path}", "-d"] + classes
    Dependencytree::TreeMain.main

    json_string = output.read
    JSON.parse(json_string)    
  end
end

