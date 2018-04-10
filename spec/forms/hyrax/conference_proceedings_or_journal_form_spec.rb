require 'rails_helper'

RSpec.describe Hyrax::ConferenceProceedingsOrJournalForm do

  let(:new_form) { described_class.new(ConferenceProceedingsOrJournal.new, nil, double("Controller")) }
  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false)}
  end
  before do
    allow(described_class).to receive(:current_ability).and_return(user)
  end

  it "responds to terms with the proper list of terms" do
    expect(described_class.terms).to include *[:resource_type, :editor, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :has_journal, :is_referenced_by, :isbn]
  end

  it "responds to date_terms" do
    expect(described_class).to respond_to :date_terms
  end
end
