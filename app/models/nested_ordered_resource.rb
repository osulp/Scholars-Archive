# frozen_string_literal: true

# nested ordered contributor object
class NestedOrderedResource < ActiveTriples::Resource
  # Usage notes and expectations can be found in the Metadata Application Profile:
  #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

  attr_accessor :destroy_item # true/false
  attr_accessor :validation_msg # string

  def final_parent
    parent
  end

  def new_record?
    id.start_with?('#')
  end

  def _destroy
    false
  end
end
