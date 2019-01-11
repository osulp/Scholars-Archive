# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_dates_section.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com', guest: false) }

  let(:work) {
    Default.new do |work|
      work.attributes = attributes
    end
  }
  let(:form) do
    Hyrax::DefaultForm.new(work, ability, controller)
  end
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/dates_section", f: f, key: 'dates_section' %>
      <% end %>
    )
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
  end

  context 'for a new object' do
    let(:work) { Default.new }

    before do
      assign(:form, form)
      render inline: form_template
    end

    it 'draws the page' do
      expect(rendered).to have_selector("form[action='/concern/defaults']")
    end

    it 'draws the selector for single and multiple value fields' do
      expect(rendered).to have_selector('select#new_date_type option', count: 9)
    end
  end

  context 'for a persisted object' do
    let(:date) { '2017-01-27' }
    let(:date_range) { '2017-05-24/2017-05-31' }

    let(:attributes) {
      {
          title: ['test'],
          creator: ['Blah'],
          rights_statement: ['blah.blah'],
          resource_type: ['blah'],
          date_available: date_range,
          date_copyright: date_range,
          date_accepted: date_range,
          date_collected: [date],
          date_reviewed: [date],
          date_created: date,
          date_issued: date,
          date_valid: date
      }
    }

    before do
      assign(:form, form)
      render inline: form_template
    end

    it 'draws the page' do
      expect(rendered).to have_selector('select#new_date_type option', count: 1)
      expect(rendered).to have_selector('div#date_fields tr.date-range', count: 3)
      expect(rendered).to have_selector('div#date_fields tr.date-default', count: 3)
    end

    it 'renders date created' do
      expect(rendered).to have_content('Date Created')
    end

    it 'renders date copyright' do
      expect(rendered).to have_content('Date of Copyright')
    end

    it 'renders date issued' do
      expect(rendered).to have_content('Date Issued')
    end

    it 'renders date valid' do
      expect(rendered).to have_content('Date Valid')
    end

    it 'renders date available' do
      expect(rendered).to have_content('Date Available')
    end

    it 'renders date accepted' do
      expect(rendered).to have_content('Date Accepted')
    end

    it 'renders date collected' do
      expect(rendered).to have_content('Date Collected')
    end

    it 'renders date reviewed' do
      expect(rendered).to have_content('Date Reviewed')
    end
  end
end
