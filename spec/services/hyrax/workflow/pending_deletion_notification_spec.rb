# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Workflow::PendingDeletionNotification do
  let(:approver) do
    User.create(email: 'admin@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:depositor) do
    User.create(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:cc_user) do
    User.create(email: 'test2@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:work) { Article.create(title: ['New Article']) }
  let(:admin_set) do
    begin
      AdminSet.find('blah')
    rescue ActiveFedora::ObjectNotFoundError
      AdminSet.create(id: 'blah',
                      title: ['title'],
                      description: ['A substantial description'],
                      edit_users: [depositor.username])
    end
  end
  let(:permission_template) do
    Hyrax::PermissionTemplate.create!(source_id: admin_set.id)
  end
  let(:workflow) do
    Sipity::Workflow.create(name: 'test', allows_access_grant: true, active: true,
                            permission_template_id: permission_template.id)
  end
  let(:entity) { Sipity::Entity.create(proxy_for_global_id: work.to_global_id.to_s, workflow_id: workflow.id) }
  let(:comment) { double('comment', comment: 'A pleasant read') }
  let(:recipients) { { 'to' => [approver], 'cc' => [cc_user] } }

  describe '.send_notification' do
    it 'sends a message to all users' do
      expect(depositor).to receive(:send_message).with(anything, "A deletion request for #{work.title[0]} (<a href=\"/concern/articles/#{work.id}\">#{work.id}</a>) was made by #{depositor.user_key} and is awaiting approval with the following comments: #{comment.comment}", anything).exactly(3).times.and_call_original
      expect { described_class.send_notification(entity: entity, user: depositor, comment: comment, recipients: recipients) }.to change { approver.mailbox.inbox.count }.by(1).and change { cc_user.mailbox.inbox.count }.by(1)
    end

    context 'without carbon-copied users' do
      let(:recipients) { { 'to' => [approver] } }

      it 'sends a message to the to user(s)' do
        expect(depositor).to receive(:send_message).twice.and_call_original
        expect { described_class.send_notification(entity: entity, user: depositor, comment: comment, recipients: recipients) }.to change { approver.mailbox.inbox.count }.by(1)
      end
    end
  end
end
