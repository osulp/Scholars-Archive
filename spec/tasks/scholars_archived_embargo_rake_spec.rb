require 'rails_helper'
require 'rake'
require 'fileutils'

describe "process_embargoes.rake" do
  let(:past_date) { 2.days.ago }
  let!(:file) do
    GenericFile.new.tap do |work|
      work.apply_depositor_metadata('test')
      work.apply_embargo(past_date.to_s, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
      work.save(validate:false)
    end
  end

  before do
    load File.expand_path("../../../lib/tasks/process_embargoes.rake", __FILE__)
  end

  describe "process_embargoes" do

    before do
      Rake::Task.define_task(:environment)
      Rake::Task["process_embargoes"].invoke
    end

    after do
      Rake::Task["process_embargoes"].reenable
      file.delete
    end


    subject { GenericFile.find(file.id) }

    it "should clear the expired embargo" do
      expect(subject).not_to be_nil
      expect(subject.embargo_release_date).to be_nil
      expect(subject.embargo_history).not_to be_nil
      expect(subject.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end

end
