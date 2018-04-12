require "dependencytree/treemain"

require 'minitest/autorun'

# Fake UUID generator with predictable results
class IntGenerator

  def initialize
    @value = 0
  end

  def uuid
    result = @value
    @value += 1
    result.to_s
  end
end

