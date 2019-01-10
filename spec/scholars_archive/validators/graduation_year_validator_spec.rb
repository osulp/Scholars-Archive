# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::Validators::GraduationYearValidator do
  describe '#validate' do
    let(:validator) { described_class.new }
    let(:correct_graduation_year) { '1925' }
    let(:incorrect_graduation_year) {}
    let(:record) {}

    context 'When an etd has an proper graduation year with other characters' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: incorrect_graduation_year)}
      let(:incorrect_graduation_year) { '1925asdfaafasdfasd' }
      it 'sets the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to eq ['Invalid value. Please ensure a year is used in this field (e.g 1908)']
      end
    end
    context 'When an etd has an improper graduation year that is only characters' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: incorrect_graduation_year)}
      let(:incorrect_graduation_year) { 'asdf' }

      it 'sets the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to eq ['Invalid value. Please ensure a year is used in this field (e.g 1908)']
      end
    end
    context 'When an etd has an improper graduation year higher than the date range' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: incorrect_graduation_year)}
      let(:incorrect_graduation_year) { '2050' }

      it 'sets the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to eq ['Invalid value. Please ensure a year is used in this field (e.g 1908)']
      end
    end
    context 'When an etd has an improper graduation year that is not of length 4' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: incorrect_graduation_year)}
      let(:incorrect_graduation_year) { '205' }

      it 'sets the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to eq ['Invalid value. Please ensure a year is used in this field (e.g 1908)']
      end
    end
    context 'When an etd has an improper graduation year higher than the date range' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: incorrect_graduation_year)}
      let(:incorrect_graduation_year) { '1800' }

      it 'sets the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to eq ['Invalid value. Please ensure a year is used in this field (e.g 1908)']
      end
    end
    context 'When an etd has a proper graduation year' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: correct_graduation_year)}
      it 'does not set the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to be_blank
      end
    end
    context 'When an etd has a nil graduation year' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: nil)}
      it 'does not set the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to be_blank
      end
    end
    context 'When an etd has an empty graduation year' do
      let(:record) {UndergraduateThesisOrProject.new(graduation_year: '')}
      it 'does not set the error on the record' do
        validator.validate(record)
        expect(record.errors['graduation_year']).to be_blank
      end
    end
  end
end
