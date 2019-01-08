# frozen_string_literal: true

require 'rails_helper'
require 'rack/test'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe OtherOptionsController, type: :controller do
  let(:valid_attributes) do
    {
      name: 'test',
      work_id: 'test123abc',
      property_name: 'other_affiliation'
    }
  end
  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end

  describe 'DELETE #destroy' do
    before do
      login_as user
      # expect(controller).to receive(:authorize!).with(:destroy, FeaturedWork).and_return(true)
    end

    it 'destroys the requested date_range' do
      date_range = OtherOption.create! valid_attributes
      expect do
        delete :destroy, params: { id: date_range.to_param }
      end.to change(OtherOption, :count).by(-1)
    end
  end
end
