require 'rails_helper'

RSpec.describe FileEditForm do
  subject { FileEditForm.new(file) }
  let(:file) { GenericFile.new }

  describe ".build_permitted_params" do
    it "should permit nested author attributes" do
      expect(described_class.build_permitted_params).to include(
        {
          :nested_authors_attributes => [
            :id,
            :_destroy,
            :name,
            :orcid
          ]
        }
      )
    end
  end

  describe "field instantiation" do
    it "should build a nested author" do
      subject

      expect(subject.model.nested_authors.length).to eq 1
    end
  end

  describe "#has_content?" do
    it "should delegate down to model's content" do
      allow(file.content).to receive(:has_content?).and_return(true)

      expect(subject.has_content?).to eq true
    end
  end
end
