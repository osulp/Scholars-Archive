# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'honors_college_theses/edit_fields/_license.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com', guest: false) }

  let(:work) do
    HonorsCollegeThesis.new do |work|
      work.attributes = attributes
    end
  end
  let(:form) do
    Hyrax::HonorsCollegeThesisForm.new(work, ability, controller)
  end
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "honors_college_theses/edit_fields/license", f: f %>
      <% end %>
    )
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
  end

  context 'for a new object' do
    let(:work) { HonorsCollegeThesis.new }

    before do
      assign(:form, form)
      render inline: form_template
    end

    it 'draws the page' do
      expect(rendered).to have_selector("form[action='/concern/honors_college_theses']")
    end

    it 'only renders CC4 licenses' do
      expect(rendered).to have_selector("select#honors_college_thesis_license option[value$='/4.0/']", count: 6)
      expect(rendered).to have_selector("select#honors_college_thesis_license option[value$='rr-r.html']", count: 1)
    end
    it 'does not render unneeded licenses' do
      expect(rendered).not_to have_selector("select#honors_college_thesis_license option[value$='zero/1.0/']")
      expect(rendered).not_to have_selector("select#honors_college_thesis_license option[value$='mark/1.0/']")
    end
  end
end
