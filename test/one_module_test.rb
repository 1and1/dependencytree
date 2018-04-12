require "dependencytree/treemain"

require 'minitest/autorun'
require "tempfile"
require "json"

# Test for parsing "one_module.rb" and comparing the output json.
class TestOneModule < Minitest::Test

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
      "uuid" => json[0]["uuid"],
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
      "uuid" => json[1]["uuid"],
      "type" => "module",
      "path" => File.absolute_path(one_module).to_s,
      "name" => "OneModule",
      "full_name" => "OneModule",
      "methods" => ["method"],
      "constants" => ["CONST"],
      "refs" => ["CONST"],
      "resolved_refs" => [json[1]["uuid"]],
      "unresolved_refs"=> []
    }
    assert_equal(one_module_expect, json[1])
  end
end

