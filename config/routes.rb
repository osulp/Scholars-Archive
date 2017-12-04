Rails.application.routes.draw do
  mount BrowseEverything::Engine => '/browse'

  resources :other_options, only: [:destroy]

  concern :oai_provider, BlacklightOaiProvider::Routes::Provider.new

  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  get '/downloads/:id(.:format)', to: 'scholars_archive/downloads#show', as: 'download'
  get '/single_use_link/download/:id(.:format)', to: 'scholars_archive/single_use_links_viewer#download', as: 'download_single_use_link'
  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :oai_provider
    concerns :searchable
    concerns :range_searchable
  end

  devise_for :users

  # For Sidekiq administration UI
  authenticate :user, ->(u) { u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end


  mount Hydra::RoleManagement::Engine => '/'
  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  get '/xmlui/handle/:handle_prefix/:handle_localname/:action', to: 'scholars_archive/handles#handle_show', as: 'handle_show_action'
  get '/xmlui/handle/:handle_prefix/:handle_localname', to: 'scholars_archive/handles#handle_show', as: 'handle_show'
  get '/xmlui/bitstream/handle/:handle_prefix/:handle_localname/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_handle', file: /.*?/, format: /[^.]+/
  get '/xmlui/bitstream/:handle_prefix/:handle_localname/:sequence_id/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download', file: /.*?/, format: /[^.]+/
  get '/jspui/handle/:handle_prefix/:handle_localname', to: 'scholars_archive/handles#handle_show', as: 'handle_show_jspui'
  get '/dspace/handle/:handle_prefix/:handle_localname', to: 'scholars_archive/handles#handle_show', as: 'handle_show_dspace'
  get '/dspace/bitstream/handle/:handle_prefix/:handle_localname/:sequence_id/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_dspace_handle', file: /.*?/, format: /[^.]+/
  get '/dspace/bitstream/:handle_prefix/:handle_localname/:sequence_id/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_dspace', file: /.*?/, format: /[^.]+/

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable
    collection do
      delete 'clear'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
