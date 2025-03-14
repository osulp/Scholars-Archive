# frozen_string_literal: true

RSpec.describe 'catalog/_index_list_default.html.erb', type: :view do
  let(:attributes) do
    { 'abstract_tesim' => ['abstract'],
      'has_model_ssim' => 'Default' }
  end
  let(:document) { SolrDocument.new(attributes) }
  let(:presenter) { double }

  before do
    allow(view).to receive(:index_presenter).and_return(presenter)
    allow(presenter).to receive(:field_value) { |field| "Testing\n#{field.field}" }
    allow(presenter).to receive(:display_type) { [ Default ] }
    allow(document).to receive(:response).and_return('highlighting' => { document.id => {} })
    render 'catalog/index_list_default', document: document
  end

  it { expect(rendered).to include 'class="col-7 preformatted"' }
  it { expect(rendered).to include 'Abstract:' }
  it { expect(rendered).to include "Testing\nabstract_tesim" }
end
