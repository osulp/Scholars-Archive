# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe User, type: :model do
  let(:user) do
    described_class.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end

  it 'has an email' do
    expect(user.email).to be_kind_of String
    expect(user.email).to eq('test@example.com')
  end

  it 'has mailbox-related methods defined' do
    expect(user).to respond_to(:mailboxer_email)
    expect(user.mailboxer_email).to eq user.email
    expect(user).to respond_to(:name)
  end
end
