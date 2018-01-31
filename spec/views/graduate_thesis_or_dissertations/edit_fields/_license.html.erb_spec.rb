require 'spec_helper'
require 'rails_helper'
RSpec.describe 'graduate_thesis_or_dissertations/edit_fields/_license.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com',guest: false) }

  let(:work) {
    GraduateThesisOrDissertation.new do |work|
      work.attributes = attributes
    end
  }
  let(:form) do
    Hyrax::GraduateThesisOrDissertationForm.new(work, ability, controller)
  end
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "graduate_thesis_or_dissertations/edit_fields/license", f: f %>
      <% end %>
    )
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
  end

  context "for a new object" do
    let(:work) { GraduateThesisOrDissertation.new }

    before do
      assign(:form, form)
      render inline: form_template
    end

    it "draws the page" do
      expect(rendered).to have_selector("form[action='/concern/graduate_thesis_or_dissertations']")
    end

    it "only renders CC4 licenses" do
      expect(rendered).to have_selector("select#graduate_thesis_or_dissertation_license option[value$='/4.0/']", count: 6)
    end
    it "does not render unneeded licenses" do
      expect(rendered).to not_have_selector("select#graduate_thesis_or_dissertation_license option[value$='zero/1.0/']")
      expect(rendered).to not_have_selector("select#graduate_thesis_or_dissertation_license option[value$='rr-r.html']")
      expect(rendered).to not_have_selector("select#graduate_thesis_or_dissertation_license option[value$='mark/1.0/']")
    end
  end
end
