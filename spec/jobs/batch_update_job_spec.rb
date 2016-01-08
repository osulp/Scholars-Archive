require 'rails_helper'

describe BatchUpdateJob do

  let(:title) { { file.id => ['File One'], file2.id => ['File Two'] }}
  let(:metadata) { { subject: [''], date_created: ['2012/01/01'], :date =>['http://id.loc.gov/vocabulary/iso639-1/pl']  }.with_indifferent_access }
  let(:visibility) { embargo }
  let(:job) { ScholarsArchive::BatchUpdateJob.new(user.user_key, batch.id, title, metadata, visibility, '2112-01-01', private_value, public_value) }

  let(:private_value) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
  let(:public_value) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
  let(:embargo) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO }

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

  before do
    allow(Sufia.queue).to receive(:push)
  end


  describe "embargo visibility" do 

    it 'should work' do
      expect {job.run}.not_to raise_error
      expect(file.reload.under_embargo?).to be true
    end
  end

  describe "uri saved as triple powered resource" do
    context "When a generic file has a uri in a uri enabled field" do

      it "should save the uri field as a TriplePoweredResource" do
        job.run
        expect(file.reload.date.first).to be_kind_of TriplePoweredResource
      end

    end
  end

end
