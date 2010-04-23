require 'test_helper'

class WordTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Word.new.valid?
  end
end
