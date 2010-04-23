require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Source.new.valid?
  end
end
