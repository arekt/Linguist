require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Exercise.new.valid?
  end
end
