require 'rails_helper'

RSpec.describe "hyrax/base/_nested_geo.html.erb" do
  let(:nested_geo_labels) { ["Corvallis"] }
  let(:solr_document) { SolrDocument.new(nested_geo_label_ssim: nested_geo_labels, nested_geo_label_tesim: nested_geo_labels) }
  let(:ability) { nil }

  let(:presenter) do
    double(Hyrax::WorkShowPresenter.new(solr_document, ability))
  end

  before do
    allow(view).to receive(:dom_class) { '' }
    allow(presenter).to receive(:nested_geo).and_return(nested_geo_labels)
    render :partial => "hyrax/base/nested_geo", :locals => {:presenter => presenter}
  end

  it "should display the nested geo label" do
    expect(rendered).to have_content "Corvallis"
  end
end