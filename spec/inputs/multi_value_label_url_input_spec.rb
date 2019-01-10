# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe 'MultiValueLabelUrlInput', type: :input do
  class Foo < ActiveFedora::Base
    # property :bar, predicate: ::RDF::URI('http://example.com/bar')
    property :bar, predicate: ::RDF::Vocab::DC.references, class_name: NestedRelatedItems
    accepts_nested_attributes_for :bar
  end

  describe '#build_field' do
    let(:foo) { Foo.new }
    let(:ref1) { NestedRelatedItems.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    let(:ref2) { NestedRelatedItems.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    before { foo.bar = [ref1, ref2] }
    let(:builder) { double('builder', object: foo, object_name: 'foo') }

    subject { MultiValueLabelUrlInput.new(builder, :bar, nil, :multi_value, {}) }

    it 'renders multi-value' do
      expect(subject).to receive(:build_field).with(ref1, Fixnum)
      expect(subject).to receive(:build_field).with(ref2, Fixnum)
      subject.input({})
    end
  end
end
