# frozen_string_literal: true

require 'rails_helper'

# SPEC: Test on the model created for favorite collection
RSpec.describe FavoriteCollection, type: :model do
  let(:user) { User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) } }
  let(:favorite_collection) { described_class.new(user: user, collection_id: 'abc123') }

  describe 'association to user' do
    it 'belongs to a user' do
      expect(favorite_collection).to respond_to(:user)
    end
  end

  describe 'validations' do
    context 'when valid' do
      it 'is valid with a user and collection_id' do
        expect(favorite_collection).to be_valid
      end
    end

    context 'when collection_id is missing' do
      it 'is invalid without a collection_id' do
        favorite_collection.collection_id = nil
        expect(favorite_collection).not_to be_valid
      end
    end

    context 'when duplicate favorite' do
      it 'is invalid if same user favorites the same collection twice' do
        described_class.create!(user: user, collection_id: 'abc123')
        expect(favorite_collection).not_to be_valid
      end
    end

    context 'when different user favorites the same collection' do
      it 'is valid' do
        other_user = User.new(email: 'test2@example.com', guest: false) { |u| u.save!(validate: false) }
        described_class.create!(user: other_user, collection_id: 'abc123')
        expect(favorite_collection).to be_valid
      end
    end

    context 'when same user favorites different collections' do
      it 'is valid' do
        described_class.create!(user: user, collection_id: 'abc123')
        different_collection = described_class.new(user: user, collection_id: 'xyz789')
        expect(different_collection).to be_valid
      end
    end
  end
end
