require 'rails_helper'

RSpec.describe "curation_concerns/base/_nested_geo_bbox.html.erb" do
  let(:nested_geo_bbox_labels) { ["Corvallis"] }
  let(:solr_document) { SolrDocument.new(nested_geo_bbox_label_ssim: nested_geo_bbox_labels,
                                         nested_geo_bbox_label_tesim: nested_geo_bbox_labels) }
  let(:ability) { nil }

  let(:presenter) do
    double(CurationConcerns::WorkShowPresenter.new(solr_document, ability))
  end

  before do
    allow(view).to receive(:dom_class) { '' }
    allow(presenter).to receive(:nested_geo_bbox).and_return(nested_geo_bbox_labels)
    render :partial => "curation_concerns/base/nested_geo_bbox", :locals => {:presenter => presenter}
  end

  it "should display the nested geo point label" do
    expect(rendered).to have_content "Corvallis"
  end
end
