require "rails_helper"
require "spec_helper"

describe "external redirection" do
  it "redirects to od" do
    get "/xmlui/handle/1957/1891"
    response.should redirect_to("http://oregondigital.org/sets/osu-scarc")
  end
end
