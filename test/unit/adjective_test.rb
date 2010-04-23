require 'test_helper'

class AdjectiveTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Adjective.new.valid?
  end
end
