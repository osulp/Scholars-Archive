# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::OtherOptionCreateSuccessService do
  let!(:user) do
    User.new(id: 1, username:'admin', email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:inbox) { user.mailbox.inbox }
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
        other_affiliation: ['Other']
    }
  }

  let(:test_degree_field_other) { ['test1 degree field other'] }
  let(:test_degree_level_other) { 'test1 degree level other' }
  let(:test_degree_name_other) { 'test1 degree name other' }
  let(:test_other_affiliation_other) { ['test1 other affiliation other'] }

  before do
    allow(user).to receive(:admin?).and_return(true)
    curation_concern.apply_depositor_metadata(user.user_key)
    curation_concern.degree_field_other = test_degree_field_other
    curation_concern.degree_level_other = test_degree_level_other
    curation_concern.degree_name_other = test_degree_name_other
    curation_concern.other_affiliation_other = test_other_affiliation_other
    curation_concern.id = 'test123'
    allow_any_instance_of(described_class).to receive(:job_user).and_return(user)
    allow_any_instance_of(described_class).to receive(:user_to_notify).and_return(user)
  end

  describe '#call' do
    subject { described_class.new(curation_concern, field: :degree_field, new_entries: test_degree_field_other) }

    it "sends Degree 'Other' entry notification mail" do
      subject.call
      expect(inbox.count).to eq(1)
      inbox.each { |msg| expect(msg.last_message.subject).to eq('Degree Field "Other" entry notification') }
    end
  end
end
