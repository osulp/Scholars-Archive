require 'rails_helper'

RSpec.describe "Date Selector", :js => true do
  context "As a logged in user " do
    let(:user_attributes) do {
      email: 'test@example.com',
      username: 'test@example.com'
    }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      login_as user
    end

    context "And ingesting a new work" do
      before do
        visit new_curation_concerns_generic_work_path
        click_link "Additional fields"
      end

      it "should have the date dropdown with date created shown by default" do
        click_link "Additional fields"
        expect(page).to have_selector('#new_date_type')
        sleep(3)
      end

      it "should allow you to select a new date type and add it to the form" do
        expect(page).to_not have_content("Date Accepted")
        select('Accepted', :from => 'new_date_type') 
        click_button("add_new_date_type")
        expect(page).to have_content("Date Accepted")
      end
    end
  end
end
