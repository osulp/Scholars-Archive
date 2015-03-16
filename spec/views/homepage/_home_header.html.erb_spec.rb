require 'rails_helper'

RSpec.describe "homepage/_home_header.html.erb" do
  let(:user) { User.new }
  let(:groups) { [] }
  describe "share your work button" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      stub_template "homepage/_marketing" => "marketing"
      render
    end
    context "when logged in" do
      let(:user) do
        u = User.new
        allow(u).to receive(:new_record?).and_return(false)
        allow(u).to receive(:groups).and_return(groups)
        u
      end
      let(:groups) {[]}
      context "and not an admin" do
        it "should not display" do
          expect(rendered).not_to have_content I18n.t("sufia.share_button")
        end
      end
      context "and they are an admin" do
        let(:groups) { ['admin'] }
        it "should display" do
          expect(rendered).to have_content I18n.t("sufia.share_button")
        end
      end
    end
  end
end
