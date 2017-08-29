require 'rails_helper'
require 'spec_helper'
RSpec.describe ScholarsArchive::Actors::AddOtherFieldOptionActor do
  let(:curation_concern) do
      GraduateThesisOrDissertation.new do |work|
        work.attributes = attributes
      end
  end
  let(:attributes) {
    {
        title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"],
        degree_field: "Other",
        degree_level: "Other",
        degree_name: "Other"
    }
  }
  let!(:user) do
    User.new(username:'admin', email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:ability) { double(current_user: user) }
  let(:env) { Hyrax::Actors::Environment.new(curation_concern, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }

  subject(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(terminator)
  end

  before do
    allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Certificate','Certificate']])
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([['Other', 'Other'],['Zoology','Zoology']])
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Zoology','Zoology']])
    allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Master of Arts (M.A.)','Master of Arts (M.A.)']])
    allow(user).to receive(:admin?).and_return(true)
    allow(terminator).to receive(:create).with(Hyrax::Actors::Environment).and_return(true)
    curation_concern.degree_field_other = test_degree_field_other
    curation_concern.degree_level_other = test_degree_level_other
    curation_concern.degree_name_other = test_degree_name_other
  end

  describe '#create' do
    let(:test_degree_field_other) { "test1 degree field other" }
    let(:test_degree_level_other) { "test1 degree level other" }
    let(:test_degree_name_other) { "test1 degree name other" }

    context 'with other values selected for degree_field, degree_field, and degree_name' do
      before do
        curation_concern.id = "test1"
      end
      it "persists other values if they don't exist" do
        expect(subject.create(env)).to be true
      end
    end
    context 'with invalid other values selected for degree_field and degree_level' do
      let(:test_degree_level_other) { "Certificate" }
      let(:test_degree_field_other) { "Zoology" }
      let(:test_degree_name_other) { "Master of Arts (M.A.)" }

      before do
        curation_concern.id = "test2"
      end
      it "raises error if the degree level already exists" do
        expect(subject.create(env)).to be false
        expect(curation_concern.errors[:degree_level_other].first).to eq 'This value already exists, please select from the list above.'
      end
      it "raises error if the degree field already exists" do
        expect(subject.create(env)).to be false
        expect(curation_concern.errors[:degree_field_other].first).to eq 'This value already exists, please select from the list above.'
      end
      it "raises error if the degree name already exists" do
        expect(subject.create(env)).to be false
        expect(curation_concern.errors[:degree_name_other].first).to eq 'This value already exists, please select from the list above.'
      end
    end
    context 'with blank "other" values selected for degree_level and degree_field and degree_name' do
      let(:test_degree_level_other) { "" }
      let(:test_degree_field_other) { "" }
      let(:test_degree_name_other) { "" }

      before do
        curation_concern.id = "test3"
      end
      it "raises error if degree_level is blank" do
        expect(subject.create(env)).to be false
        expect(curation_concern.errors[:degree_level_other].first).to eq "Please provide a value for 'Other'"
      end
      it "raises error if degree_field is blank" do
        expect(subject.create(env)).to be false
        expect(curation_concern.errors[:degree_field_other].first).to eq "Please provide a value for 'Other'"
      end
      it "raises error if degree_name is blank" do
        expect(subject.create(env)).to be false
        expect(curation_concern.errors[:degree_name_other].first).to eq "Please provide a value for 'Other'"
      end
    end
  end

  describe '#update' do
    context 'with other values selected for degree_field and degree_level and degree_name' do
      let(:test_degree_level_other) { "test2 degree level other" }
      let(:test_degree_field_other) { "test2 degree field other" }
      let(:test_degree_name_other) { "test2 degree name other" }

      before do
        curation_concern.id = "test4"
      end
      it "persists other values if they don't exist" do
        expect(subject.update(env)).to be true
      end
    end
  end
end
