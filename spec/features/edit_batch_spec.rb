require 'rails_helper'
describe "edit batch form and find proper date fields", type: :feature do
  let(:user) do
    User.create(:username => "test", :group_list => "admin")
  end

  let(:file_title) { 'test file' }
  let(:batch) { Batch.create }
  let(:field_labels) {{'Date Accepted' => '2',
                       'Date Available' => '3',
                       'Date Copyrighted' => '4',
                       'Date Collected' => '5',
                       'Date Issued' => '6',
                       'Date Submitted' => '7',
                       'Date Modified' => '8',
                       'Date Valid' => '9'}}
  let(:file) do
    GenericFile.new(batch: batch) do |f|
      f.title = [file_title]
      f.label = "test"
      f.apply_depositor_metadata(user.user_key)
      f.save!
    end
  end

  before do
    login_as user, :scope => :user
    visit "/batches/#{file.batch.id}/edit"
    page.find('#show_addl_descriptions').click
  end

  context "when ingesting a file", js:true do
    it "should display proper date fields" do
      field_labels.each_pair do |key, value|
        expect(page).to_not have_content key
        add_date_type(value)
        expect(page).to have_content key
      end
    end
  end
end
def add_date_type(selected_option)
  find('#new_date_type').find(:xpath, 'option['+selected_option+']').select_option
  find('#add_new_date_type').click
end
