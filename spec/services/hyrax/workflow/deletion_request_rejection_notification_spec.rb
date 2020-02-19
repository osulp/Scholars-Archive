# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Workflow::DeletionRequestRejectionNotification do
  let(:approver) { User.find_by_user_key('admin@example.com') }
  let(:depositor) { User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password') }
  let(:cc_user) { User.create(email: 'test2@example.com', password: 'password', password_confirmation: 'password') }
  let(:work) { Article.create(title: ['New Article']) }
  let(:admin_set) do
    AdminSet.create(title: ['article admin set'],
                    description: ['some description'],
                    edit_users: [depositor.user_key])
  end
  let(:permission_template) do
    Hyrax::PermissionTemplate.create!(admin_set_id: admin_set.id)
  end
  let(:workflow) do
    Sipity::Workflow.create(name: 'test', allows_access_grant: true, active: true,
                            permission_template_id: permission_template.id)
  end
  let(:entity) { Sipity::Entity.create(proxy_for_global_id: work.to_global_id.to_s, workflow_id: workflow.id) }
  let(:comment) { double('comment', comment: 'A pleasant read') }
  let(:recipients) { { 'to' => [depositor], 'cc' => [cc_user] } }

  describe '.send_notification' do
    it 'sends a message to all users' do
      expect(approver).to receive(:send_message)
                              .with(anything,
                                    "The deletion request for #{work.title[0]} (<a href=\"/concern/articles/#{work.id}\">#{work.id}</a>) "\
      "was rejected by #{approver.user_key}. #{comment.comment}",
                                    anything).exactly(3).times.and_call_original

      expect { described_class.send_notification(entity: entity, user: approver, comment: comment, recipients: recipients) }
          .to change { depositor.mailbox.inbox.count }.by(1)
                  .and change { cc_user.mailbox.inbox.count }.by(1)
    end

    context 'without carbon-copied users' do
      let(:recipients) { { 'to' => [depositor] } }

      it 'sends a message to the to user(s)' do
        expect(approver).to receive(:send_message).exactly(2).times.and_call_original
        expect { described_class.send_notification(entity: entity, user: approver, comment: comment, recipients: recipients) }
            .to change { depositor.mailbox.inbox.count }.by(1)
      end
    end
  end
end