require 'rails_helper'

RSpec.describe GenericFile do
  it "should be able to persist" do
    expect{GenericFile.new.save}.not_to raise_error
  end
end
