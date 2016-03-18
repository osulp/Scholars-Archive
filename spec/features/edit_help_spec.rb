require 'rails_helper'

RSpec.describe "edit button for help" do
  let(:user) { }
  before do
    login_as(user, :scope => :user) if user
  end
  context "as an anonymous user" do
    context "visit help page" do
      before do
        visit root_path
        click_link "Help"
      end
      it "should display the edit button" do
        validate_button_does_not_exist
      end
      context "visit faculty help page" do
        before do
          click_link "Faculty FAQ"
        end
        it "should display the edit button" do
          validate_button_does_not_exist
        end
      end

      context "visit graduate help page" do
        before do
          click_link "Graduate Student FAQ"
        end
        it "should display the edit button" do
          validate_button_does_not_exist
        end
      end

      context "visit undergraduate help page" do
        before do
          click_link "Undergraduate Student FAQ"
        end
        it "should display the edit button" do
          validate_button_does_not_exist
        end
      end
    end


  end

  context "as an authenticated user" do
    let(:user) do
      User.create(:username => "test", :email => 'noreply@oregonstate.edu', :group_list => "admin")
    end
    context "visit help page" do
      before do
        visit root_path
        click_link "Help"
      end
      it "should display the edit button" do
        validate_button_exists
      end
      context "visit faculty help page" do
        before do
          click_link "Faculty FAQ"
        end
       it "should display the edit button" do
         validate_button_exists
       end
      end

      context "visit graduate help page" do
        before do
          click_link "Graduate Student FAQ"
        end
        it "should display the edit button" do
          validate_button_exists
        end
      end

      context "visit undergraduate help page" do
        before do
          click_link "Undergraduate Student FAQ"
        end
        it "should display the edit button" do
          validate_button_exists
        end
      end
    end

  end
end
def validate_button_exists
  expect(page).to have_selector(".tinymce-form")
end

def validate_button_does_not_exist
  expect(page).not_to have_selector(".tinymce-form")
end
