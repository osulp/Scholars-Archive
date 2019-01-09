# frozen_string_literal: true

# allows for other option choice in form
class OtherOption < ApplicationRecord
  validates :name, :work_id, :property_name, :presence => true
end
