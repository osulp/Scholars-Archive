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
      let(:test_degree_level_other) { "test1 degree level other" }
      let(:test_degree_field_other) { "test1 degree field other" }

      before do
        allow(terminator).to receive(:create).with(Hyrax::Actors::Environment).and_return(true)
        curation_concern.apply_depositor_metadata(user.user_key)
        curation_concern.degree_field_other = test_degree_field_other
        curation_concern.degree_level_other = test_degree_level_other
        curation_concern.save!
      end
      it "persists other values if they don't exist" do
        expect(subject.create(env)).to be true
        expect(other_options.first.name).to be_in [test_degree_field_other, test_degree_level_other]
        expect(other_options.second.name).to be_in [test_degree_field_other, test_degree_level_other]
      end
    end
  end

  describe '#update' do
    context 'with other values selected for degree_field and degree_level' do
      let(:attributes) { { title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"], degree_field: "Other", degree_level: "Other" } }
      let(:test_degree_level_other) { "test2 degree level other" }
      let(:test_degree_field_other) { "test2 degree field other" }

      before do
        allow(terminator).to receive(:update).with(Hyrax::Actors::Environment).and_return(true)
        curation_concern.apply_depositor_metadata(user.user_key)
        curation_concern.degree_field_other = test_degree_field_other
        curation_concern.degree_level_other = test_degree_level_other
        curation_concern.save!
      end
      it "persists other values if they don't exist" do
        expect(subject.update(env)).to be true
        expect(other_options.first.name).to be_in [test_degree_field_other, test_degree_level_other]
        expect(other_options.second.name).to be_in [test_degree_field_other, test_degree_level_other]
      end
    end
  end
end