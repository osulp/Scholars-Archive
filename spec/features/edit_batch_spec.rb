require 'rails_helper'
describe "edit batch form and find proper date fields", type: :feature do
  let(:user) do
    User.create(:username => "test", :email => "noreply@oregonstate.edu", :group_list => "admin")
  end

  let(:file_title) { 'test file' }
  let(:batch) { Batch.create }
  let(:field_labels) {{'Date Accepted' => '2',
                       'Date Available' => '3',
                       'Date Collected' => '4',
                       'Date Copyrighted' => '5',
                       'Date Issued' => '6',
                       'Date Modified' => '7',
                       'Date Published' => '8',
                       'Date Submitted' => '9',
                       'Date Valid' => '10'}}
  let(:file) do
    GenericFile.new(batch: batch) do |f|
      f.title = [file_title]
      f.label = "test"
      f.apply_depositor_metadata(user.user_key)
      f.save!
    end
  end

  before do
    Resque.inline = true
    login_as user, :scope => :user
    visit "/batches/#{file.batch.id}/edit"
    page.find('#show_addl_descriptions').click
  end

  context "when ingesting a file", :js => true do
    xit "should only display the default date field" do
      # expect(page).to have_content "Date Created"
      # field_labels.each_pair do |key, value|
      #   expect(page).to_not have_content key
      # end
    end
    xit "should display proper date fields when the Add Date button is clicked" do
      # field_labels.each_pair do |key, value|
      #   expect(page).to_not have_content key
      #   add_date_type(value)
      #   expect(page).to have_content key
      # end
    end
    xit "should display the default values and switchy button", :js => true do
      # expect(page).to have_selector("input[value = 'http://id.loc.gov/vocabulary/iso639-1/en']")
      # expect(page).to have_selector("input[value = 'http://id.loc.gov/authorities/names/n80017721']")
      # expect(page).to have_selector ".glyphicon-random"
    end
  end
end
def add_date_type(selected_option)
  find('#new_date_type').find(:xpath, 'option['+selected_option+']').select_option
  find('#add_new_date_type').click
end
