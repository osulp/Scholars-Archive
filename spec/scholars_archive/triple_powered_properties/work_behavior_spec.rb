require 'rails_helper'

RSpec.describe ScholarsArchive::TriplePoweredProperties::WorkBehavior do
  let(:url) { 'http://opaquenamespace.org/ns/TestVocabulary/TestTerm' }
  subject { GenericWork.new({ subject: [ url ], title: ['TestTest'] }) }
  let(:label) { 'hello' }

  before do
    subject.save
  end

  xit 'should have triple powered properties with labels' do
    expect(subject.triple_powered_properties).to be_a_kind_of(Array)
    expect(subject.uri_labels(:subject)[url]).to be_a_kind_of(Array)
    expect(subject.uri_labels(:subject)[url]).to include(label)
  end
end
