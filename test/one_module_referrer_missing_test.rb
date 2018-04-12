require "test_common"
require "int_generator"

require 'minitest/autorun'
require "tempfile"
require "json"

# Tests the referer module(OneModuleReferrer), but doesn't load the referred module (OneModule).
class OneModuleReferrerMissingTest < Minitest::Test

  def test_one_module_referrer_missing
    one_module_ref = "test/example/one_module_referrer.rb"
    json = TestCommon.call([one_module_ref])
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

    one_module_ref_expect =   {
      "uuid" => "1",
      "type" => "module",
      "path" => File.absolute_path(one_module_ref).to_s,
      "name" => "OneModuleReferrer",
      "full_name" => "OneModuleReferrer",
      "methods" => ["method"],
      "constants" => [],
      "refs" => ["OneModule::CONST"],
      "resolved_refs" => [],
      "unresolved_refs"=> ["OneModule::CONST"]
    }
    assert_equal(one_module_ref_expect, json[1])
  end
end

