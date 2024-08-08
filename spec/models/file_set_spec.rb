# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileSet do
  # CREATE: Build variables and stub to test on external resource
  subject(:model) { described_class.new }

  let(:url) { 'http://test.com' }

  # TEST NO.1: Testing to make sure the external resource exist
  describe 'ext_relation_metadata' do
    it 'accepts ext_relation metadata' do
      expect(model).to respond_to(:ext_relation)
    end
  end

  # TEST NO.2: Test to make sure it can handle if the item has link or not
  describe 'ext_relation?' do
    it 'returns false when an ext_relation is not present' do
      expect(model.ext_relation?).to be false
    end

    it 'returns true when an ext_relation is present' do
      model.ext_relation = url
      expect(model.ext_relation?).to be true
    end
  end
end
