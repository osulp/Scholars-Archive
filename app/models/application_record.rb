# frozen_string_literal: true

# application record abstract class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
