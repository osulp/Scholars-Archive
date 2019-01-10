# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

describe 'external redirection' do
  it 'redirects to od' do
    get '/xmlui/handle/1957/1891'
    response.should redirect_to('https://oregondigital.org/sets/osu-scarc')
  end
  it 'redirects to od items' do
    get '/xmlui/handle/1957/3745'
    response.should redirect_to('https://oregondigital.org/catalog/oregondigital:fx71ch37t')
  end
  it 'redirects to ir collections' do
    get '/xmlui/handle/1957/14384'
    response.should redirect_to('https://ir.library.oregonstate.edu/catalog?q=A.%20Personal%2FPolitical%2FOfficial%20Records&search_field=dspace_collection')
  end
end
