require 'rails_helper'

describe GenericFiles::Actor do
  
  let(:user) { User.new(:username => "banana") }
  let(:generic_file) { GenericFile.new }
  let(:actor) { GenericFiles::Actor.new(generic_file, user, {}) }
  let(:uploaded_file) { fixture_file_upload('/world.png','image/png') }

  describe "#update_metadata" do
    it "should update year_created based on date_created" do
      expect(generic_file.date_created.first).to eq nil
      actor.update_metadata({date_created:['2012/01/01']}, 'open')
      expect(generic_file.date_created).to eq ['2012/01/01']
    end
  end
end
