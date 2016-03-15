require 'rails_helper'

describe EmbargoesMailer do

  describe 'embargoes lifted notification' do
    context 'with no embargoes to lift' do
      let(:mail) { EmbargoesMailer.embargoes_lifted_email([], 'noreply@oregonstate.edu', 'noreply@oregonstate.edu', 'Test', nil) }
      it 'renders a title' do
        expect(mail.body.encoded).to match("Scholars Archive Embargo Lifting Status")
      end

      it 'renders 0 embargoes lifted' do
        expect(mail.body.encoded).to match("0 embargoes were lifted.")
      end
    end
    context 'with 1 embargo to lift' do
      let(:items) { [ GenericFile.new(:id => 'bogus', :label => "test") ] }
      let(:mail) {
        EmbargoesMailer.embargoes_lifted_email(items, 'noreply@oregonstate.edu', 'noreply@oregonstate.edu', 'Test', nil)
      }

      it 'renders a title' do
        expect(mail.body.encoded).to match("Scholars Archive Embargo Lifting Status")
      end

      it 'renders 1 embargo lifted' do
        expect(mail.body.encoded).to match("1 embargo was lifted.")
        items.each do |item|
          expect(mail.body.encoded).to match(item.label)
        end
      end
    end
    context 'with multiple embargoes to lift' do
      let(:items) { [
        GenericFile.new(:id => 'bogus1', :label => "test1"),
        GenericFile.new(:id => 'bogus2', :label => "test2"),
        GenericFile.new(:id => 'bogus3', :label => "test3"),
        GenericFile.new(:id => 'bogus4', :label => "test4"),

      ] }
      let(:mail) {
        EmbargoesMailer.embargoes_lifted_email(items, 'noreply@oregonstate.edu', 'noreply@oregonstate.edu', 'Test', nil)
      }

      it 'renders a title' do
        expect(mail.body.encoded).to match("Scholars Archive Embargo Lifting Status")
      end

      it 'renders multiple embargoes lifted' do
        expect(mail.body.encoded).to match("#{items.count} embargoes were lifted.")
        items.each do |item|
          expect(mail.body.encoded).to match(item.label)
        end
      end
    end
    context 'with an error while processing' do
      let(:mail) { EmbargoesMailer.embargoes_lifted_email([], 'noreply@oregonstate.edu', 'noreply@oregonstate.edu', 'Test', 'ERROR TEXT HERE') }
      it 'renders the error text' do
        expect(mail.body.encoded).to match('ERROR TEXT HERE')
      end
    end
  end
end
