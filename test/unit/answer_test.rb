require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  should "be valid with factory" do
    assert_valid Factory.build(:answer)
  end
end
