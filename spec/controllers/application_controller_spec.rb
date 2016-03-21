require 'rails_helper'

class BogusController < ApplicationController; end

RSpec.describe "ApplicationController before_action", :type => :controller do
  controller BogusController do
    def index
      render :text => "SUCCESS!"
    end
  end

  let(:user) { User.new(:username => "blahblah", :email => "blah@blah") }

  before do
    controller.instance_variable_set(:@current_user, user)
  end

  context "when valid user accesses an action" do
    it "should return the action" do
      get :index
      expect(response.body).to match("SUCCESS!")
    end
  end
  context "when user with default_email accesses an action" do
    let(:user) {
      u = User.new(:username => "blahblah")
      u.email = u.default_email
      u
    }
    it "should redirect the user to their profile edit page" do
      get :index
      expect(response).to redirect_to("/users/#{user[:username]}/edit")
    end
  end
end
