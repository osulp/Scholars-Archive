require 'spec_helper'
require 'rails_helper'

describe 'MultiValueDateInput', type: :input do
  class Foo < ActiveFedora::Base
    property :multi_value_date, predicate: ::RDF::URI('http://example.com/bar')
  end

  describe '#build_field' do
    let(:foo) { Foo.new }
    let(:date1) { "2017-08-03" }
    let(:date2) { "2017-08-12" }
    before { foo.multi_value_date = [date1, date2] }
    let(:builder) { double('builder', object: foo, object_name: 'foo') }

    subject { MultiValueDateInput.new(builder, :multi_value_date, nil, :multi_value, {}) }

    it 'renders multi-value' do
      expect(subject).to receive(:build_field).with(date1, Fixnum)
      expect(subject).to receive(:build_field).with(date2, Fixnum)
      expect(subject).to receive(:build_field).with('', Fixnum)
      subject.input({})
    end
  end
end