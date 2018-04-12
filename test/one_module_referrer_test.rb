require "dependencytree/treemain"
require "dependencytree/classmodel"

require "test_common"
require "int_generator"

require 'minitest/autorun'
require "tempfile"
require "json"

# Test for parsing "one_module.rb" and comparing the output json.
class OneModuleReferrerTest < Minitest::Test

  def test_one_module_referrer
    one_module = "test/example/one_module.rb"
    one_module_ref = "test/example/one_module_referrer.rb"
    json = TestCommon.call([one_module, one_module_ref])
    assert(json.length == 3)
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

    one_module_ref_expect =   {
      "uuid" => "2",
      "type" => "module",
      "path" => File.absolute_path(one_module_ref).to_s,
      "name" => "OneModuleReferrer",
      "full_name" => "OneModuleReferrer",
      "methods" => ["method"],
      "constants" => [],
      "refs" => ["OneModule::CONST"],
      "resolved_refs" => ["1"],
      "unresolved_refs"=> []
    }
    assert_equal(one_module_ref_expect, json[2])
  end
end

