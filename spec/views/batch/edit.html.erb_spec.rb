require 'rails_helper'

RSpec.describe "batch/edit.html.erb" do
  let(:batch) { Batch.create }
  let(:generic_file) do
    GenericFile.new.tap do |f|
      f.apply_depositor_metadata("bob")
    end
  end
  let(:form) { BatchEditForm.new(generic_file) }
  before do
    assign :batch, batch
    assign :form, form
    allow(controller).to receive(:current_user).and_return(User.create(:username => "bla@bla.org"))
    render
  end

  it "should render a rights statement" do
    expect(rendered).to have_selector "select[name='generic_file[rights][]']"
    expect(rendered).not_to have_selector "select[id='generic_file_rights'][multiple='multiple']"
  end
end
