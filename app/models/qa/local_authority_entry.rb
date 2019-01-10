# frozen_string_literal: true

# local qa authority base object
class Qa::LocalAuthorityEntry < ApplicationRecord
  belongs_to :local_authority
end
