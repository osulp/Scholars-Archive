require 'rails_helper'

RSpec.describe "generic_files/_descriptions.html.erb" do
  let(:form) { FileEditForm.new(file) }
  let(:file) { GenericFile.new }
  before do
    allow(form).to receive(:terms).and_return([:rights])
    assign :form, form
    render
  end
  it "should render a single-select rights field" do
    expect(rendered).to have_selector "select[name='generic_file[rights][]']"
    expect(rendered).not_to have_selector "select[id='generic_file_rights'][multiple='multiple']"
  end
end
