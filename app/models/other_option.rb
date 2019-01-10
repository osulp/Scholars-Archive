# frozen_string_literal: true

class OtherOption < ApplicationRecord
  validates :name, :work_id, :property_name, :presence => true
end
