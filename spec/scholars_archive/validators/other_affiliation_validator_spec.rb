# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::Validators::OtherAffiliationValidator do
  describe '#validate' do
    let(:validator) { described_class.new }
    let(:record) do
      GraduateThesisOrDissertation.new do |work|
        work.attributes = attributes
      end
    end

    let!(:depositor) do
      User.new(username:'admin', email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
    end

    let(:attributes) {
      {
          title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'],
          other_affiliation: ['Other'],
          depositor: depositor.username
      }
    }

    let(:test_other_affiliation_other) { [ 'test entry one', 'test entry two'] }

    before do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([%w[Other Other], %w[Certificate Certificate]])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([%w[Other Other], %w[Zoology Zoology]])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other], %w[Zoology Zoology]])
      allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['Master of Arts (M.A.)', 'Master of Arts (M.A.)']])
      allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['http://id.loc.gov/authorities/names/n80017721', 'Oregon State University']])
      allow_any_instance_of(ScholarsArchive::OtherAffiliationService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['http://opaquenamespace.org/ns/subject/OregonStateUniversityBioenergyMinorProgram', 'Oregon State University Bioenergy Minor Program']])
      record.other_affiliation_other = test_other_affiliation_other
      record.current_username = depositor.username
      validator.validate(record)
    end

    context 'with invalid other values selected for degree_field and degree_level' do
      let(:test_other_affiliation_other) { [ 'Oregon State University Bioenergy Minor Program'] }

      it 'raises error if the other_affiliation entry already exists' do
        expect(record.errors[:other_affiliation_other].first).to eq "This 'Other' value: \"Oregon State University Bioenergy Minor Program\" already exists, please select from the list."
      end
    end
  end
end
