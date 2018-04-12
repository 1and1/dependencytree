require "dependencytree/treemain"
require "dependencytree/classmodel"

require "int_generator"

require 'minitest/autorun'
require "tempfile"
require "json"

# Test for parsing "one_module.rb" and comparing the output json.
class TestOneModule < Minitest::Test

  def setup
    Dependencytree::ClassModel.generator = IntGenerator.new
  end

  def test_one_module
    output = Tempfile.new("json")
    one_module = "test/example/one_module.rb"    
    ARGV[0..-1] = ["-o#{output.path}", one_module]
    Dependencytree::TreeMain.main

    json_string = output.read
    assert(output.length > 0)

    json = JSON.parse(json_string)
    
    assert(json.length == 2)
    kernel_expect =   {
      "uuid" => "0",
      "type" => "module",
      "path" => nil,
      "name" => "Kernel",
      "full_name" => "Kernel",
      "methods" => [],
      "constants" => [],
      "refs" => [],
      "resolved_refs" => [],
      "unresolved_refs"=> []
    }
    assert_equal(kernel_expect, json[0])

    one_module_expect =   {
      "uuid" => "1",
      "type" => "module",
      "path" => File.absolute_path(one_module).to_s,
      "name" => "OneModule",
      "full_name" => "OneModule",
      "methods" => ["method"],
      "constants" => ["CONST"],
      "refs" => ["CONST"],
      "resolved_refs" => ["1"],
      "unresolved_refs"=> []
    }
    assert_equal(one_module_expect, json[1])
  end
end

