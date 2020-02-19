# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Workflow::MetadataOnlyRecord do
  let(:user) { User.find_by_user_key('admin@example.com') }
  let(:work) { Article.create(title: ['New Article'], visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
  let(:file_set) { FileSet.new }
  let(:file_set_actor) { Hyrax::Actors::FileSetActor.new(file_set, user) }
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

  let(:workflow_method) { described_class }

  before do
    file_set_actor.attach_to_work(work)
  end

  describe '.call' do
    it 'makes file sets private' do
      expect { described_class.call(target: work, user: user) }
          .to change { work.file_sets[0].visibility }
                  .from(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
                  .to(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE)
    end
  end
end