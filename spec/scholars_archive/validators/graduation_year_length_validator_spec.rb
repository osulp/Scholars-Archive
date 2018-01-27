require 'rails_helper'

RSpec.describe ScholarsArchive::Validators::GraduationYearLengthValidator do
  describe "#validate" do
    let(:validator) { described_class.new }
    let(:correct_graduation_year) { "1925" }
    let(:incorrect_graduation_year) { "1925blah" }
    let(:record) {}

    context "When an etd has an improper graduation year" do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: incorrect_graduation_year)}
      it "set an error on the record" do
        validator.validate(record)
        expect(record.errors["graduation_year"]).to eq ["Invalid value. Please ensure a year is used in this field (e.g 1908)"]
      end
    end
    context "When an etd has a proper graduation year" do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: correct_graduation_year)}
      it "set an error on the record" do
        validator.validate(record)
        expect(record.errors["graduation_year"]).to be_blank
      end
    end

  end
end
