require 'rails_helper'

RSpec.describe HelpController do
  describe "#page" do
    context "when given a bad page" do
      it "should return a 404" do
        expect{ get :page, :page => "bla" }.to raise_error ActionController::RoutingError
      end
    end
    context "when given a good page" do
      before do
        get :page, :page => "undergraduate"
      end
      it "should set @page" do
        expect(assigns(:page)).to be_kind_of ContentBlock
      end
      it "should render the appropriate template" do
        expect(response).to render_template "page"
      end
    end
  end
end
