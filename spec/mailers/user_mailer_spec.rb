require 'rails_helper'

describe UserMailer do

  describe 'sending notifications' do
    let(:user) { User.new(:username => "blahblah", :email => "noreply@oregonstate.edu") }
    context 'to support_invalid_user' do
      let(:error_message) { "bogus error message" }
      let(:mail) { UserMailer.support_invalid_user(user, error_message) }
      it 'renders a title' do
        expect(mail.body.encoded).to match("Scholars Archive Invalid User Detected")
      end
      it 'renders details' do
        expect(mail.body.encoded).to match(user[:username])
        expect(mail.body.encoded).to match(user[:email])
      end
      it 'renders an error message' do
        expect(mail.body.encoded).to match(error_message)
      end
      context 'without an error message' do
        let(:error_message) { '' }
        it 'does not render an error' do
          expect(mail.body.encoded).to_not match("id='error_message'")
        end
      end
    end
    context 'to shared_access_to' do
      let(:access_type) { "edit" }
      let(:generic_file) { GenericFile.new(:id => 'whatwhat', :title => ["super dooper title"]) }
      let(:mail) { UserMailer.shared_access_to(user, generic_file, access_type) }
      it 'renders a title' do
        expect(mail.body.encoded).to match("You've been granted edit access to 'super dooper title'")
      end
      it 'renders a link' do
        expect(mail.body.encoded).to match('Click here to access the archive.')
      end
    end
  end
end
