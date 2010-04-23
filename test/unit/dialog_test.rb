require 'test_helper'

class DialogTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Dialog.new.valid?
  end
end
