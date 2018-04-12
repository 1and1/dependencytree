require "dependencytree/treemain"

require 'minitest/autorun'

# Test for basic calling of the project inclusive help.
class TestSimple < Minitest::Test

  def test_start_program_without_options
    ARGV[0..-1] = []
    Dependencytree::TreeMain.main
  end

  def test_start_program_with_help
    pp File.absolute_path(".")
    ARGV[0..-1] = ["-h"]
    Dependencytree::TreeMain.main
  end
end

