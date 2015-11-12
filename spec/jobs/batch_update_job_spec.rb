require 'rails_helper'

describe BatchUpdateJob do

  let(:user) { User.create(:username => "banana") }
  let(:batch) { Batch.create }

  let!(:file) do
    GenericFile.new(batch: batch) do |file|
      file.apply_depositor_metadata("banana")
      file.save!
    end
  end

  let!(:file2) do
    GenericFile.new(batch: batch) do |file|
      file.apply_depositor_metadata("banana")
      file.save!
    end
  end

  describe "embargo visibility" do 
    let(:title) { { file.id => ['File One'], file2.id => ['File Two'] }}
    let(:metadata) do
      { read_groups_string: '', read_users_string: 'archivist1, archivist2',
        subject: [''], date_created: ['2012/01/01'] }.with_indifferent_access
    end
  
    let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO }
    let(:job) { BatchUpdateJob.new(user.user_key, batch.id, title, metadata, visibility, '2112-01-01', Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }

    before do
      allow(Sufia.queue).to receive(:push)
    end

    it 'should work' do
      expect {job.run}.not_to raise_error
      expect(file.reload.under_embargo?).to be true
    end

  end

end
