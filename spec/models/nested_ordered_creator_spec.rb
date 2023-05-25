# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe NestedOrderedCreator do
  subject { NestedOrderedCreator.new(uri, parent) }

  let(:uri) { RDF::Node.new }
  let(:parent) { Default::GeneratedResourceSchema.new }

  describe 'instantiation' do
    context 'with a string hash uri' do
      let(:uri) { '#bla_46' }

      it 'should make it a URI' do
        expect(subject.rdf_subject).to eq RDF::URI('#bla_46')
      end
    end
  end
end
