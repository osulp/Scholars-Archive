# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'ostruct'

describe ScholarsArchive::OsuApiService do
  let(:service) { described_class.new }
  let(:person) do
    { 'id' => 123,
      'type' => 'directory',
      'attributes' =>
     { 'firstName' => 'Josh',
       'lastName' => 'Gum',
       'fullName' => 'Gum, Josh',
       'primaryAffiliation' => 'Employee',
       'jobTitle' => 'Analyst Programmer',
       'department' => 'Library',
       'departmentMailingAddress' =>
       "Library\nOregon State University\n121 The Valley Library\nCorvallis, OR 97331-4501",
       'homePhoneNumber' => nil,
       'homeAddress' => nil,
       'officePhoneNumber' => '1 541 555 1212',
       'officeAddress' =>
       "The Valley Library\n4083 Valley Library\nCorvallis, OR 97331",
       'faxNumber' => nil,
       'emailAddress' => 'bogus.email',
       'username' => 'bogususername',
       'alternatePhoneNumber' => nil,
       'osuuid' => 12_345_678_901 },
      'links' => { 'self' => 'https://api.oregonstate.edu/v1/directory/12345678901' } }
  end
  let(:response_status) { 200 }
  let(:response_reason_phrase) { 'ok' }
  let(:response_body) { { data: [person] } }
  let(:response) do
    r = OpenStruct.new
    r.status = response_status
    r.reason_phrase = response_reason_phrase
    r.body = JSON.dump(response_body)
    r
  end

  before do
    allow_any_instance_of(described_class).to receive(:get_token).and_return('fakie')
  end

  it 'has a token' do
    expect(service.token).to eq('fakie')
  end

  describe '#get_person' do
    before do
      allow(service).to receive(:get).and_return(response)
    end

    it 'returns a person' do
      expect(service.get_person(person['username'])).to eq(person)
    end

    context 'when no person is found' do
      let(:response_status) { 400 }
      let(:response_reason_phrase) { 'bogus' }

      it 'returns nil' do
        expect(service.get_person(person['username'])).to be_nil
      end
    end
  end
end
