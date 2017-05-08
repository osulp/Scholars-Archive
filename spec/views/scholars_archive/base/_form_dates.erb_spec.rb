require 'spec_helper'
require 'rails_helper'
RSpec.describe 'scholars_archive/base/_form_dates.html.erb', type: :view do
  let(:work) do
    DefaultWork.new
  end

  let(:ability) { double }

  let(:form) do
    Hyrax::DefaultWorkForm.new(work, ability, controller)
  end

  before do
    assign(:form, form)
  end


  let(:page) do
    view.simple_form_for form do |f|
      render 'scholars_archive/base/form_dates', f: f
    end
  end

  context "for a new object" do
    let(:work) { DefaultWork.new }
    it "draws the page" do
      expect(page).to have_selector("form[action='/concern/default_works']")
      expect(page).to have_selector("select#new_date_type option", count: 8)
    end

  end

  context "for a persisted object" do
    let(:date) { "2017-01-27" }
    let(:date_range) { "2017-05-24/2017-05-31" }
    let!(:work) do
      DefaultWork.new do |work|
        work.title = ["Jill's Research"]
        work.date_available = date_range
        work.date_copyright = date_range
        work.date_accepted = date_range
        work.date_collected = date
        work.date_created = date
        work.date_issued = date
        work.date_valid = date
        (1..25).each do |i|
          work.keyword << ["keyword#{format('%02d', i)}"]
        end
      end
    end
    it "draws the page" do
      expect(page).to have_selector("select#new_date_type option", count: 1)
      expect(page).to have_selector("div#date_fields tr.date-range", count: 3)
      expect(page).to have_selector("div#date_fields tr.date-default", count: 4)
    end

    it "renders date created" do
      expect(page).to have_content("Date Created")
    end

    it "renders date copyright" do
      expect(page).to have_content("Date Copyright")
    end

    it "renders date issued" do
      expect(page).to have_content("Date Issued")
    end

    it "renders date valid" do
      expect(page).to have_content("Date Valid")
    end

    it "renders date available" do
      expect(page).to have_content("Date Available")
    end

    it "renders date accepted" do
      expect(page).to have_content("Date Accepted")
    end

    it "renders date collected" do
      expect(page).to have_content("Date Collected")
    end
  end
end
