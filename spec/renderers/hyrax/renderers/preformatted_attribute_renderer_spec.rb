# frozen_string_literal: true

RSpec.describe Hyrax::Renderers::PreformattedAttributeRenderer do
  subject { described_class.new(:abstract, "Bob\nRoss\nFTW").render }

  describe '#attribute_to_html' do
    it { is_expected.to include "Bob\nRoss\nFTW" }
    it { is_expected.to include "class='preformatted'" }
  end
end
