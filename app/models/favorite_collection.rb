# frozen_string_literal: true

# Add favorite collection model for user via
# `rails generate migration CreateFavoriteCollections`
class FavoriteCollection < ApplicationRecord
  belongs_to :user

  validates :collection_id, presence: true
  validates :collection_id, uniqueness: { scope: :user_id }
end
