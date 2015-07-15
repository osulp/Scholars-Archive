require 'rails_helper'

RSpec.describe ScholarsArchive::Fields::InputFactory do
  subject { described_class.new(base_factory, decorator) }
  let(:base_factory) { object_double(HydraEditor::Fields::Factory) }
  let(:decorator) { object_double(HasHintOption) }
  let(:object) { instance_double(FileEditForm) }
  let(:decorated_input) { double("decorated input") }
  let(:input) { double("input") }
  let(:property) { :lcsubject }
  let(:result) { subject.create(object, property) }

  describe "#create" do
    it "decorate the input" do
      allow(base_factory).to receive(:create).and_return(input)
      allow(decorator).to receive(:new).and_return(decorated_input)

      expect(result).to eq decorated_input
      expect(decorator).to have_received(:new).with(input)
      expect(base_factory).to have_received(:create).with(object, :lcsubject)
    end
  end
end
