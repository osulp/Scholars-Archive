require 'rails_helper'

RSpec.describe "records/edit_fields/_default.html.erb" do
  let(:form_name) { "generic_file" }
  let(:file) { GenericFile.new }
  let(:form) { FileEditForm.new(file) }
  let(:f) { SimpleForm::FormBuilder.new(form_name, form, self, {}) }

  before do
    assign :form, form
    assign :f, f
  end

  context "with hidden_fields" do
    before do
      key = form.class.hidden_fields.first
      render :partial => "records/edit_fields/default", :locals => { :f => f, :key => key }
    end
    it "should not render anything" do
      expect(rendered).to be_empty
    end
  end

  context "with non-hidden fields" do
    let(:key) { form.class.required_fields.first }

    before do
      render :partial => "records/edit_fields/default", :locals => { :f => f, :key => key }
    end
    it "should render the field" do
      expect(rendered).to include("#{form_name}[#{key.to_s}]")
    end
  end
end
