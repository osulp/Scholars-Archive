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

  let(:invalid_attributes) do
    {
      name: nil,
      work_id: nil,
      property_name: nil
    }
  end

  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end

  describe 'DELETE #destroy' do
    context 'with permission to destroy' do
      before do
        # Disables the Devise authentication filter to allow testing as unauthorized user
        OtherOptionsController.skip_before_action :authenticate_user!
      end
      it 'destroys the requested date_range' do
        date_range = OtherOption.create! valid_attributes
        expect do
          delete :destroy, params: { id: date_range.to_param }
        end.to change(OtherOption, :count).by(-1)
      end
    end

    context 'without permission to destroy' do
      before do
        # Re-enables the Devise authentication filter to allow testing as authorized user
        OtherOptionsController.before_action :authenticate_user!
      end

      it 'does not destroy the requested date_range' do
        date_range = OtherOption.create! valid_attributes
        expect do
          delete :destroy, params: { id: date_range.to_param }
        end.not_to change(OtherOption, :count)
      end
    end
  end
end
