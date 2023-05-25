# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::Validators::OtherOptionDegreeValidator do
  describe '#validate' do
    let(:validator) { described_class.new }
    let(:record) do
      GraduateThesisOrDissertation.new do |work|
        work.attributes = attributes
      end
    end

    let!(:depositor) do
      User.new(username: 'admin', email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
    end

    let(:attributes) do
      {
        title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'],
        degree_field: ['Other'],
        degree_level: 'Other',
        degree_name: ['Other'],
        degree_grantors: 'Other',
        other_affiliation: ['Other'],
        depositor: depositor.username
      }
    end

    let(:test_degree_field_other) { ['test1 degree field other'] }
    let(:test_degree_level_other) { 'test1 degree level other' }
    let(:test_degree_name_other) { ['test1 degree name other'] }
    let(:test_degree_grantors_other) { 'test1 degree grantors other' }
    let(:test_other_affiliation_other) { [ 'test entry one', 'test entry two'] }

    before do
      allow(depositor).to receive(:admin?).and_return(true)
      allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([%w[Other Other], %w[Certificate Certificate]])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([%w[Other Other], %w[Zoology Zoology]])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other], %w[Zoology Zoology]])
      allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['Master of Arts (M.A.)', 'Master of Arts (M.A.)']])
      allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['http://id.loc.gov/authorities/names/n80017721', 'Oregon State University']])
      record.degree_field_other = test_degree_field_other
      record.degree_level_other = test_degree_level_other
      record.degree_name_other = test_degree_name_other
      record.degree_grantors_other = test_degree_grantors_other
      record.current_username = depositor.username
      validator.validate(record)
    end

    context 'with invalid other values selected for degree_field and degree_level' do
      let(:test_degree_level_other) { 'Certificate' }
      let(:test_degree_field_other) { ['Zoology'] }
      let(:test_degree_name_other) { ['Master of Arts (M.A.)'] }
      let(:test_degree_grantors_other) { 'Oregon State University' }
      let(:test_other_affiliation_other) { [ 'Bioenergy Minor Program'] }

      it 'raises error if the degree level already exists' do
        expect(record.errors[:degree_level_other].first).to eq "This 'Other' value: \"Certificate\" already exists, please select from the list."
      end

      it 'raises error if the degree field already exists' do
        expect(record.errors[:degree_field_other].first).to eq "This 'Other' value: \"Zoology\" already exists, please select from the list."
      end

      it 'raises error if the degree name already exists' do
        expect(record.errors[:degree_name_other].first).to eq "This 'Other' value: \"Master of Arts (M.A.)\" already exists, please select from the list."
      end

      it 'raises error if the degree grantors already exists' do
        expect(record.errors[:degree_grantors_other].first).to eq "This 'Other' value: \"Oregon State University\" already exists, please select from the list."
      end
    end

    context 'with blank "other" values selected for degree_level and degree_field and degree_name and degree_grantors' do
      let(:test_degree_level_other) { '' }
      let(:test_degree_field_other) { [] }
      let(:test_degree_name_other) { [] }
      let(:test_degree_grantors_other) { '' }

      before do
        # curation_concern.id = "test3"
      end

      it 'raises error if degree_level is blank' do
        expect(record.errors[:degree_level_other].first).to eq nil
      end

      it 'raises error if degree_field is blank' do
        expect(record.errors[:degree_field_other].first).to eq nil
      end

      it 'raises error if degree_name is blank' do
        expect(record.errors[:degree_name_other].first).to eq nil
      end

      it 'raises error if degree_grantors is blank' do
        expect(record.errors[:degree_grantors_other].first).to eq nil
      end
    end
  end
end
