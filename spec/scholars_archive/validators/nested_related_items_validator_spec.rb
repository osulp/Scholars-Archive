require 'rails_helper'

RSpec.describe ScholarsArchive::Validators::NestedRelatedItemsValidator do
  describe "#validate" do
    let(:validator) { described_class.new }
    let(:record) do
      GraduateThesisOrDissertation.new do |work|
        work.attributes = attributes
      end
    end

    let!(:depositor) do
      User.new(username:'admin', email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
    end

    let(:test_label) { 'Oregon Digital' }
    let(:test_url) { 'https://oregondigital.org/catalog/' }
    let(:test_item) do
      {
          label: test_label,
          related_url: test_url
      }
    end

    let(:attributes) {
      {
          title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"],
          depositor: depositor.username,
          nested_related_items_attributes: [test_item]
      }
    }

    before do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Certificate','Certificate']])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([['Other', 'Other'],['Zoology','Zoology']])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Zoology','Zoology']])
      allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Master of Arts (M.A.)','Master of Arts (M.A.)']])
      allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['http://id.loc.gov/authorities/names/n80017721','Oregon State University']])
      allow_any_instance_of(ScholarsArchive::OtherAffiliationService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['http://opaquenamespace.org/ns/subject/OregonStateUniversityBioenergyMinorProgram', 'Oregon State University Bioenergy Minor Program']])
      record.current_username = depositor.username
      validator.validate(record)
    end

    context 'with a related item with no url' do
      let(:test_item) do
        {
            label: test_label,
            related_url: ""
        }
      end

      it "raises error that the item is missing a url" do
        expect(record.errors[:related_items].first).to eq "One or more items are missing label/related url values. Please provide both label and url values for each related item entered."
      end
    end

    context 'with a related item with no label' do
      let(:test_item) do
        {
            label: "",
            related_url: test_url
        }
      end

      it "raises error that the item is missing the label" do
        expect(record.errors[:related_items].first).to eq "One or more items are missing label/related url values. Please provide both label and url values for each related item entered."
      end
    end
  end
end
