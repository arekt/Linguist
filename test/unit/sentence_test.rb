require 'test_helper'

class SentenceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Sentence.new.valid?
  end
end
