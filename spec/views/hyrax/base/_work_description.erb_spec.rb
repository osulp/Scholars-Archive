require 'rails_helper'
require 'spec_helper'
RSpec.describe 'hyrax/base/_work_description.erb', type: :view do
  let(:url) { "http://example.com" }
  let(:rights_statement_uri) { 'http://rightsstatements.org/vocab/InC/1.0/' }
  let(:work) {
    Default.new do |w|
      w.title = ['test']
      w.rights_statement = [rights_statement_uri]
      w.save!
    end
  }
  let(:solr_document) do
    SolrDocument.new(work.to_solr)
  end
  let(:ability) { double }
  let(:presenter) do
    DefaultPresenter.new(solr_document, ability)
  end
  let(:workflow_presenter) do
    double('workflow_presenter', badge: 'Foobar')
  end
  let(:page) { Capybara::Node::Simple.new(rendered) }
  before do
    allow(presenter).to receive(:workflow).and_return(workflow_presenter)
    assign(:presenter, presenter)
    render 'hyrax/base/work_description.erb', presenter: presenter
  end

  it 'shows citeable url' do
    expect(page).to have_content 'Citeable URL'
    expect(page).to have_content 'http://test.host/concern/defaults/'+presenter.id
  end

end
