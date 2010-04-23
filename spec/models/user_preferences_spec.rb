require 'spec_helper'

describe UserPreferences do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :pref => 1
    }
  end

  it "should create a new instance given valid attributes" do
    UserPreferences.create!(@valid_attributes)
  end
end
