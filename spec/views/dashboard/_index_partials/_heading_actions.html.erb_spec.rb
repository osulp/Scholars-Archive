require 'rails_helper'

RSpec.describe "dashboard/_index_partials/_heading_actions" do
  let(:user) do
    u = User.new
    allow(u).to receive(:groups).and_return(groups)
    u
  end
  let(:groups) { [] }
  before do
    allow(controller).to receive(:current_user).and_return(user)
    render
  end
  describe "create collection button" do
    context "when not an admin" do
      it "should not display" do
        expect(rendered).not_to include t('sufia.dashboard.create_collection')
      end
    end
    context "when an admin" do
      let(:groups) { ['admin'] }
      it "should display" do
        expect(rendered).to include t('sufia.dashboard.create_collection')
      end
    end
  end
  describe "upload button" do
    context "when not an admin" do
      it "should not display" do
        expect(rendered).not_to include t('sufia.dashboard.upload')
      end
    end
    context "when an admin" do
      let (:groups) { ['admin'] }
      it "should display" do
        expect(rendered).to include t('sufia.dashboard.upload')
      end
    end
  end
end
