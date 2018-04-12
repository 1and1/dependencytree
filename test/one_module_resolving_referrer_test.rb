require "test_common"
require "int_generator"

require 'minitest/autorun'
require "tempfile"
require "json"

# Test reference after top module resolving.
class OneModuleResolvingReferrerTest < Minitest::Test

  def test_one_module_referrer
    one_module = "test/example/one_module.rb"
    one_module_ref_ref = "test/example/one_module_resolving_referrer.rb"
    json = TestCommon.call([one_module, one_module_ref_ref])
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

    one_module_res_ref_expect =   {
      "uuid" => "2",
      "parent_uuid" => "1",
      "type" => "module",
      "path" => File.absolute_path(one_module_ref_ref).to_s,
      "name" => "OneModuleResolvingReferrer",
      "full_name" => "OneModule::OneModuleResolvingReferrer",
      "methods" => ["method"],
      "constants" => [],
      "refs" => ["CONST"],
      "resolved_refs" => ["1"], # the outer-module-reference OneModule::CONST
      "unresolved_refs"=> []
    }
    assert_equal(one_module_res_ref_expect, json[2])
  end
end

