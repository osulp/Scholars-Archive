require 'rails_helper'

RSpec.describe "help/page" do
  before do
    assign(:page, ContentBlock.new(:name => "test"))
    render
  end
  it "should render a title" do
    expect(rendered).to include t('help.types.test')
  end
end
