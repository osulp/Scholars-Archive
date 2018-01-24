require 'rails_helper'

RSpec.describe Hyrax::ContactFormController do
  let(:user) {User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false)}}
  routes { Hyrax::Engine.routes }
  let(:required_params) do
    {
      category: "Depositing content",
      name: "Rose Tyler",
      email: "rose@timetraveler.org",
      subject: "The Doctor",
      message: "Run."
    }
  end
  let(:contact_form) {Hyrax::ContactForm.new(required_params)}

  before { sign_in(user) }

  describe "#create" do
    before { post :create, params: { contact_form: params } }
    context "when recaptcha is enabled" do
      let(:params) { required_params }
      context "and the recaptcha is not verified" do
        before do
          allow(controller).to receive(:verify_recaptcha).with(contact_form).and_return(false)
        end
        it "rejects the email and renders the new page" do
          expect(controller).to redirect_to :new
        end
      end
    end
  end

end
