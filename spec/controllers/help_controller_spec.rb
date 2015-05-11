require 'rails_helper'

RSpec.describe HelpController do
  describe "#faculty" do
    it "should render faculty template" do
      get :faculty

      expect(response).to render_template "faculty"
    end
  end

  describe "#graduate" do
    it "should render graduate template" do
      get :graduate
      
      expect(response).to render_template "graduate"
    end
  end

  describe "#undergraduate" do
    it "should render undergraduate template" do
      get :undergraduate

      expect(response).to render_template "undergraduate"
    end
  end
end
