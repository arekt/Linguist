require 'test_helper'

class AdjectivesTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Adjectives.new.valid?
  end
end
