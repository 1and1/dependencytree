require "test_common"

require 'minitest/autorun'

# Parse the Dependencytree program itself.
class SelfTest < Minitest::Test

  def test_self_test
    json = TestCommon.call(["lib"])
    assert(json.length > 3)
    by_full_name = json.each_with_object({})  { |clazz, hash| hash[clazz["full_name"]] = clazz}

    # check whether the ClassModel is known
    assert(!by_full_name["Dependencytree::ClassModel"].nil?)
  end
end

