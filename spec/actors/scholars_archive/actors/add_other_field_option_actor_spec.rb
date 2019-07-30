# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
RSpec.describe ScholarsArchive::Actors::AddOtherFieldOptionActor do
  let(:curation_concern) do
      GraduateThesisOrDissertation.new do |work|
        work.attributes = attributes
      end
  end
  let(:attributes) {
    {
      title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'],
      degree_field: ['Other'],
      degree_level: 'Other',
      degree_name: ['Other'],
      degree_grantors: 'Other',
      other_affiliation: ['Other']
    }
  }
  let!(:user) do
    User.new(username:'admin', email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:ability) { double(current_user: user) }
  let(:env) { Hyrax::Actors::Environment.new(curation_concern, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }

  subject(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(terminator)
  end

  before do
    allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([%w[Other Other], %w[Certificate Certificate]])
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([%w[Other Other], %w[Zoology Zoology]])
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other], %w[Zoology Zoology]])
    allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['Master of Arts (M.A.)', 'Master of Arts (M.A.)']])
    allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['http://id.loc.gov/authorities/names/n80017721', 'Oregon State University']])
    allow_any_instance_of(ScholarsArchive::OtherAffiliationService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['http://opaquenamespace.org/ns/subject/OregonStateUniversityBioenergyMinorProgram', 'Bioenergy Minor Program']])
    allow(user).to receive(:admin?).and_return(true)
    allow(terminator).to receive(:create).with(Hyrax::Actors::Environment).and_return(true)
    curation_concern.degree_field_other = test_degree_field_other
    curation_concern.degree_level_other = test_degree_level_other
    curation_concern.degree_name_other = test_degree_name_other
    curation_concern.degree_grantors_other = test_degree_grantors_other
    curation_concern.other_affiliation_other = test_other_affiliation_other
  end

  describe '#create' do
    before do
      curation_concern.id = 'test1'
    end

    context 'persists valid values' do
      let(:test_degree_level_other) { 'test1 degree level other' }
      let(:test_degree_field_other) { ['test1 degree field other'] }
      let(:test_degree_name_other) { ['test1 degree name other'] }
      let(:test_degree_grantors_other) { 'test1 degree grantors other' }
      let(:test_other_affiliation_other) { ['test1 other affiliation other'] }

      let(:attributes) {
        {
          title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'],
          degree_field: ['Other'],
          degree_level: 'Other',
          degree_name: ['Other'],
          degree_grantors: 'Other',
          other_affiliation: ['Other'],
          degree_field_other: test_degree_field_other,
          degree_level_other: test_degree_level_other,
          degree_name_other: test_degree_name_other,
          degree_grantors_other: test_degree_grantors_other,
          other_affiliation_other: test_other_affiliation_other
        }
      }

      it 'runs the environment on create' do
        expect(subject.create(env)).to be true
        expect(OtherOption.find_by(property_name: 'degree_field')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'degree_level')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'degree_name')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'degree_grantors')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'other_affiliation')).to be_a_kind_of(OtherOption)
      end
    end

    context 'should not persist invalid values' do
      let(:test_degree_level_other) { '' }
      let(:test_degree_field_other) { [''] }
      let(:test_degree_name_other) { [''] }
      let(:test_degree_grantors_other) { '' }
      let(:test_other_affiliation_other) { [''] }

      it 'runs the environment on update' do
        expect(subject.create(env)).to be true
        expect(OtherOption.find_by(property_name: 'degree_field')).to be_nil
        expect(OtherOption.find_by(property_name: 'degree_level')).to be_nil
        expect(OtherOption.find_by(property_name: 'degree_name')).to be_nil
        expect(OtherOption.find_by(property_name: 'degree_grantors')).to be_nil
        expect(OtherOption.find_by(property_name: 'other_affiliation')).to be_nil
      end
    end
  end

  describe '#update' do
    before do
      curation_concern.id = 'test4'
    end

    context 'persist valid values' do
      let(:test_degree_level_other) { 'test2 degree level other' }
      let(:test_degree_field_other) { ['test2 degree field other'] }
      let(:test_degree_name_other) { ['test2 degree name other'] }
      let(:test_degree_grantors_other) { 'test2 degree grantors other' }
      let(:test_other_affiliation_other) { ['test2 other affiliation other'] }

      let(:attributes) {
        {
          title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'],
          degree_field: ['Other'],
          degree_level: 'Other',
          degree_name: ['Other'],
          degree_grantors: 'Other',
          other_affiliation: ['Other'],
          degree_field_other: test_degree_field_other,
          degree_level_other: test_degree_level_other,
          degree_name_other: test_degree_name_other,
          degree_grantors_other: test_degree_grantors_other,
          other_affiliation_other: test_other_affiliation_other
        }
      }

      it 'runs the environment on update' do
        expect(subject.update(env)).to be true
        expect(OtherOption.find_by(property_name: 'degree_field')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'degree_level')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'degree_name')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'degree_grantors')).to be_a_kind_of(OtherOption)
        expect(OtherOption.find_by(property_name: 'other_affiliation')).to be_a_kind_of(OtherOption)
      end
    end

    context 'should not persist options in the database given invalid values' do
      let(:test_degree_level_other) { '' }
      let(:test_degree_field_other) { [''] }
      let(:test_degree_name_other) { [''] }
      let(:test_degree_grantors_other) { '' }
      let(:test_other_affiliation_other) { [''] }

      it 'runs the environment on update' do
        expect(subject.update(env)).to be true
        expect(OtherOption.find_by(property_name: 'degree_field')).to be_nil
        expect(OtherOption.find_by(property_name: 'degree_level')).to be_nil
        expect(OtherOption.find_by(property_name: 'degree_name')).to be_nil
        expect(OtherOption.find_by(property_name: 'degree_grantors')).to be_nil
        expect(OtherOption.find_by(property_name: 'other_affiliation')).to be_nil
      end
    end
  end
end
