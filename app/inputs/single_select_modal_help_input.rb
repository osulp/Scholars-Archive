class SingleSelectModalHelpInput < SelectWithModalHelpInput
  def input_type
    'single_select_modal_help'.freeze
  end

  private

  def collection_inputs
    tags = []
    collection.each_with_index do |value, index|
      tags << build_field(value, index)
    end
    tags.reduce(:<<)
  end
end
