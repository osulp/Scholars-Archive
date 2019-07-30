# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OtherOption, type: :model do
  it 'is valid with valid attributes' do
    expect(described_class.new(name: 'test', work_id: 'test123abc', property_name: 'degree_name')).to be_valid
  end
  it 'is not valid without a proper attributes' do
    other = described_class.new(name: nil, work_id: nil, property_name: nil)
    expect(other).to_not be_valid
  end
end
