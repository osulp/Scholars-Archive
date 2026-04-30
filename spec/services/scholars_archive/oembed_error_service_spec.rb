# frozen_string_literal:true

require 'rails_helper'

RSpec.describe ScholarsArchive::OembedErrorService do
  let(:depositor) do
    User.create(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:audit_user) do
    User.create(email: 'admin') { |u| u.save!(validate: false) }
  end
  let(:inbox) { depositor.mailbox.inbox }
  let(:messages) { ['ERROR ERROR ERROR'] }

  describe '#call' do
    subject(:service) { described_class.new(depositor, messages) }

    before do
      allow(User).to receive(:audit_user).and_return(audit_user)
      allow(User).to receive(:batch_user).and_return(audit_user)
      service.call
    end

    it { expect(inbox.count).to eq(1) }

    it 'sends error mail with the proper subject' do
      inbox.each do |msg|
        expect(msg.last_message.subject).to eq('Erroring oEmbed content')
      end
    end

    it 'sends error mail with the proper message' do
      inbox.each do |msg|
        expect(msg.last_message.body).to include(messages.first)
      end
    end
  end
end
