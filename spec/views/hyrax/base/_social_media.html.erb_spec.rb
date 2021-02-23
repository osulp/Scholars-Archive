# frozen_string_literal: true

RSpec.describe 'hyrax/base/_social_media.html.erb', type: :view do
  let(:url) { 'http://example.com/' }
  let(:title) { 'Example' }
  let(:page) do
    render partial: 'hyrax/base/social_media', locals: { share_url: url, page_title: title }
    Capybara::Node::Simple.new(rendered)
  end

  it 'renders various social media share button' do
    expect(page).to have_link '', href: 'https://facebook.com/sharer/sharer.php?u=http%3A%2F%2Fexample.com%2F'
  end
  it 'renders Twitter share button' do
    expect(page).to have_link '', href: 'https://twitter.com/intent/tweet/?text=Example&url=http%3A%2F%2Fexample.com%2F'
  end
  it 'renders Copy link button' do
    expect(page).to have_button 'Copy link'
  end
end
