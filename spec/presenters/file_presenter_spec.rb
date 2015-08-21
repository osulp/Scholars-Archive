require 'rails_helper'

RSpec.describe FilePresenter do
  subject { FilePresenter.new(file) }

  let(:file) { GenericFile.new }

  describe "#nested_authors_attributes=" do
    it "should delegate down to the object" do
      allow(file).to receive(:nested_authors_attributes=)

      subject.nested_authors_attributes = {}

      expect(file).to have_received(:nested_authors_attributes=).with({})
    end
    it "should respond to it" do
      expect(subject).to respond_to :nested_authors_attributes=
    end
  end
end
