# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe MultiValueOrderedInput, type: :input do
  class FooBar < ActiveFedora::Base
    property :nested_ordered_creator, predicate: ::RDF::Vocab::DC11.creator, class_name: NestedOrderedCreator
    accepts_nested_attributes_for :nested_ordered_creator
  end

  describe '#collection' do
    subject { MultiValueOrderedInput.new(builder, :nested_ordered_creator, nil, :multi_value, {}) }

    let(:foo) { FooBar.new }
    let(:creator1) { NestedOrderedCreator.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    let(:creator2) { NestedOrderedCreator.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    let(:creator3) { NestedOrderedCreator.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    let(:creator4) { NestedOrderedCreator.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    let(:creator5) { NestedOrderedCreator.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    let(:creator6) { NestedOrderedCreator.new(RDF::Node.new, Default::GeneratedResourceSchema.new) }
    let(:builder) { double('builder', object: foo, object_name: 'foo') }

    before do
      creator1.creator = ['creator0']
      creator1.index = ['0']

      creator2.creator = ['creator21']
      creator2.index = ['21']

      creator3.creator = ['creator1']
      creator3.index = ['1']

      creator4.creator = ['creator10']
      creator4.index = ['10']

      creator5.creator = ['creator2']
      creator5.index = ['2']

      creator6.creator = ['creator3']
      creator6.index = ['3']

      foo.nested_ordered_creator = [creator1, creator2, creator3, creator4, creator5, creator6]
    end

    it 'renders multi-value and checks order' do
      expect(subject).to receive(:build_field).with(creator1, Integer)
      expect(subject).to receive(:build_field).with(creator2, Integer)
      expect(subject).to receive(:build_field).with(creator3, Integer)
      expect(subject).to receive(:build_field).with(creator4, Integer)
      expect(subject).to receive(:build_field).with(creator5, Integer)
      expect(subject).to receive(:build_field).with(creator6, Integer)
      expect(subject.send(:collection).map { |c| c.creator.first }).to eq %w[creator0 creator1 creator2 creator3 creator10 creator21]
      subject.input({})
    end
  end
end
