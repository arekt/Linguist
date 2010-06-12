require 'test_helper'

class KnowledgeTestTest < ActiveSupport::TestCase
  should "be valid with factory" do
    assert_valid Factory.build(:knowledge_test)
  end
end
