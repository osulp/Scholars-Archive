Rails.application.routes.draw do
  mount BrowseEverything::Engine => '/browse'
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'
  mount Hydra::RoleManagement::Engine => '/'
  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'

  concern :oai_provider, BlacklightOaiProvider::Routes::Provider.new
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new

  root 'hyrax/homepage#index'

  get '/downloads/:id(.:format)', to: 'scholars_archive/downloads#show', as: 'download'
  get '/single_use_link/download/:id(.:format)', to: 'scholars_archive/single_use_links_viewer#download', as: 'download_single_use_link'
  get '/dashboard/shares(.:format)', to: 'scholars_archive/shares#index', as: 'dashboard_shares'

  get '/xmlui', to: 'hyrax/homepage#index'
  get '/xmlui/handle/:handle_prefix/:handle_localname/:action', to: 'scholars_archive/handles#handle_show', as: 'handle_show_action'
  get '/xmlui/handle/:handle_prefix/:handle_localname', to: 'scholars_archive/handles#handle_show', as: 'handle_show'
  get '/xmlui/bitstream/handle/:handle_prefix/:handle_localname/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_handle', file: /.*?/, format: /[^.]+/
  get '/xmlui/bitstream/:handle_prefix/:handle_localname/:sequence_id/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download', file: /.*?/, format: /[^.]+/
  get '/xmlui/*path', to: 'hyrax/homepage#index'
  
  get '/jspui', to: 'hyrax/homepage#index'  
  get '/jspui/handle/:handle_prefix/:handle_localname/:action', to: 'scholars_archive/handles#handle_show', as: 'handle_show_action_jspui'  
  get '/jspui/handle/:handle_prefix/:handle_localname', to: 'scholars_archive/handles#handle_show', as: 'handle_show_jspui'
  get '/jspui/bitstream/handle/:handle_prefix/:handle_localname/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_handle_jspui', file: /.*?/, format: /[^.]+/
  get '/jspui/bitstream/:handle_prefix/:handle_localname/:sequence_id/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_jspui', file: /.*?/, format: /[^.]+/
  get '/jspui/*path', to: 'hyrax/homepage#index'

  get '/dspace', to: 'hyrax/homepage#index'  
  get '/dspace/handle/:handle_prefix/:handle_localname', to: 'scholars_archive/handles#handle_show', as: 'handle_show_dspace'
  get '/dspace/bitstream/handle/:handle_prefix/:handle_localname/:sequence_id/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_dspace_handle', file: /.*?/, format: /[^.]+/
  get '/dspace/bitstream/:handle_prefix/:handle_localname/:sequence_id/:file(.:format)', to: 'scholars_archive/handles#handle_download', as: 'handle_download_dspace', file: /.*?/, format: /[^.]+/
  get '/dspace/*path', to: 'hyrax/homepage#index'

  resources :other_options, only: [:destroy]
  resources :welcome, only: 'index'
  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :oai_provider
    concerns :searchable
    concerns :range_searchable
  end
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end
  resources :bookmarks do
    concerns :exportable
    collection do
      delete 'clear'
    end
  end

  devise_for :users

  # For Sidekiq administration UI
  authenticate :user, ->(u) { u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
  
  curation_concerns_basic_routes
end
