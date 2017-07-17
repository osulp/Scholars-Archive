require 'rails_helper'
require 'spec_helper'
RSpec.describe ScholarsArchive::Actors::AddOtherFieldOptionActor do
  let(:curation_concern) do
      GraduateThesisOrDissertation.new do |work|
        work.attributes = attributes
        work.save!
      end
  end
  let(:ability) { double }
  let(:user) do
    User.new(email: 'test@example.com',guest: false) { |u| u.save!(validate: false)}
  end
  let(:env) { Hyrax::Actors::Environment.new(curation_concern, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }
  let(:other_options) { OtherOption.all.to_a }

  subject(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(terminator)
  end

  describe '#create' do
    context 'with other values selected for degree_field and degree_level' do
      let(:attributes) { { title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"], degree_field: "Other", degree_level: "Other" } }

      before do
        allow(terminator).to receive(:create).with(Hyrax::Actors::Environment).and_return(true)
        curation_concern.apply_depositor_metadata(user.user_key)
        curation_concern.degree_field_other = "test degree field other"
        curation_concern.degree_level_other = "test degree level other"
        curation_concern.save!
      end
      it "persists other values if they don't exist" do
        expect(subject.create(env)).to be true
        degree_field_other = OtherOption.find_by(name: "test degree field other", property_name: "degree_field", work_id: curation_concern.id)
        degree_level_other = OtherOption.find_by(name: "test degree level other", property_name: "degree_level", work_id: curation_concern.id)
        expect(other_options).to include(degree_field_other)
        expect(other_options).to include(degree_level_other)
      end
    end
  end

  describe '#update' do
    context 'with other values selected for degree_field and degree_level' do
      let(:attributes) { { title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"], degree_field: "Other", degree_level: "Other" } }
      before do
        allow(terminator).to receive(:update).with(Hyrax::Actors::Environment).and_return(true)
        curation_concern.apply_depositor_metadata(user.user_key)
        curation_concern.degree_field_other = "test degree field other"
        curation_concern.degree_level_other = "test degree level other"
        curation_concern.save!
      end
      it "persists other values if they don't exist" do
        expect(subject.update(env)).to be true
        degree_field_other = OtherOption.find_by(name: "test degree field other", property_name: "degree_field", work_id: curation_concern.id)
        degree_level_other = OtherOption.find_by(name: "test degree level other", property_name: "degree_level", work_id: curation_concern.id)
        expect(other_options).to include(degree_field_other)
        expect(other_options).to include(degree_level_other)
      end
    end
  end
end