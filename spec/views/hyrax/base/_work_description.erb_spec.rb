require 'rails_helper'
require 'spec_helper'
RSpec.describe 'hyrax/base/_work_description.erb', type: :view do
  let(:url) { "http://example.com" }
  let(:rights_statement_uri) { 'http://rightsstatements.org/vocab/InC/1.0/' }
  let(:work) {
    Default.new do |w|
      w.title = ['test']
      w.rights_statement = [rights_statement_uri]
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

  let(:test_sorted_all_options) do
    [
        ["Adult Education - {1989..1990,1995,2001,2016}", "http://opaquenamespace.org/ns/osuDegreeFields/OGvwFaYi"],
        ["Animal Breeding - 1952", "http://opaquenamespace.org/ns/osuDegreeFields/KWzvXUyz"],
    ]
  end
  let(:test_sorted_current_options) do
    [
        ["Adult Education - {1989..1990,1995,2001,2016}", "http://opaquenamespace.org/ns/osuDegreeFields/OGvwFaYi"],
    ]
  end
  let(:page) { Capybara::Node::Simple.new(rendered) }
  before do
    allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Certificate','Certificate']])
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options_truncated).and_return(test_sorted_current_options)
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return(test_sorted_all_options)
    allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Master of Arts (M.A.)','Master of Arts (M.A.)']])
    allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['http://id.loc.gov/authorities/names/n80017721','Oregon State University']])
    allow_any_instance_of(ScholarsArchive::OtherAffiliationService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['http://opaquenamespace.org/ns/subject/OregonStateUniversityBioenergyMinorProgram', 'Oregon State University Bioenergy Minor Program']])
    allow(presenter).to receive(:workflow).and_return(workflow_presenter)
    allow(presenter).to receive(:id).and_return('blah')
    assign(:presenter, presenter)
    render 'hyrax/base/work_description.erb', presenter: presenter
  end

  it 'shows citeable url' do
    expect(page).to have_content 'Citeable URL'
    expect(page).to have_content 'http://test.host/concern/defaults/'+presenter.id
  end

end
