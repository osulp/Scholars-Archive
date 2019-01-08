# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/base/_form.erb', type: :view do
  let(:current_user) { User.new(username: 'admin', email: 'test@example.com', guest: false) }
  let(:ability) { double }
  let(:form) do
    Hyrax::DefaultForm.new(work, ability, controller)
  end
  let(:academic_unit_sorted_all_options) do
    [
      ['Accounting - 1979/1992, 2009/open', 'http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG'],
      ['Animal Sciences - 1984/2013', 'http://opaquenamespace.org/ns/osuAcademicUnits/EaDtECbp']
    ]
  end
  let(:academic_unit_sorted_current_options) do
    [
      ['Accounting - 1979/1992, 2009/open', 'http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG'],
      ['Animal Sciences - 1984/2013', 'http://opaquenamespace.org/ns/osuAcademicUnits/EaDtECbp']
    ]
  end
  let(:test_sorted_all_options) do
    [
      ['Adult Education - {1989..1990,1995,2001,2016}', 'http://opaquenamespace.org/ns/osuDegreeFields/OGvwFaYi'],
      ['Animal Breeding - 1952', 'http://opaquenamespace.org/ns/osuDegreeFields/KWzvXUyz']
    ]
  end
  let(:test_sorted_current_options) do
    [
      ['Adult Education - {1989..1990,1995,2001,2016}', 'http://opaquenamespace.org/ns/osuDegreeFields/OGvwFaYi']
    ]
  end
  let(:work) do
    Default.new do |w|
      w.title = ['test']
    end
  end
  let(:curation_concern) { work }
  let(:options_presenter) { double(select_options: []) }

  before do
    allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_all_options).and_return(academic_unit_sorted_all_options)
    allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_current_options).and_return(academic_unit_sorted_current_options)
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return(test_sorted_all_options)
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options_truncated).and_return(test_sorted_current_options)
    allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([%w[Other Other], %w[Certificate Certificate]])
    allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['Master of Arts (M.A.)', 'Master of Arts (M.A.)']])
    allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['http://id.loc.gov/authorities/names/n80017721', 'Oregon State University']])
    allow_any_instance_of(ScholarsArchive::OtherAffiliationService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['http://opaquenamespace.org/ns/subject/OregonStateUniversityBioenergyMinorProgram', 'Oregon State University Bioenergy Minor Program']])
    allow(Hyrax::AdminSetOptionsPresenter).to receive(:new).and_return(options_presenter)
    stub_template('hyrax/base/_form_progress.html.erb' => 'Progress')
    stub_template('hyrax/base/_form_relationships.html.erb' => 'Relationships')
    allow(work).to receive(:new_record?).and_return(true)
    allow(work).to receive(:member_ids).and_return([1, 2])
    allow_any_instance_of(User).to receive(:admin?).and_return(true)
    allow(work).to receive(:current_username).and_return('admin')
    allow(ability).to receive(:current_user).and_return(current_user)
    allow(curation_concern.model_name).to receive(:name).and_return('default')
    allow(controller).to receive(:current_user).and_return(current_user)
    assign(:form, form)
    allow(controller).to receive(:controller_name).and_return('batch_uploads')
    allow(controller).to receive(:action_name).and_return('new')
  end

  context 'batch upload off' do
    before do
      allow(Flipflop).to receive(:batch_upload?).and_return(false)
      render
    end

    it 'shows link to LibGuide' do
      expect(rendered).to have_link 'ScholarsArchive@OSU User Guide'
    end
  end
end
