Rails.application.routes.draw do
  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  mount BrowseEverything::Engine => '/browse'

  resources :other_options, only: [:destroy]

  concern :oai_provider, BlacklightOaiProvider::Routes.new

  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  get '/downloads/:id(.:format)', to: 'scholars_archive/downloads#show', as: 'download'
  get '/single_use_link/download/:id(.:format)', to: 'scholars_archive/single_use_links_viewer#download', as: 'download_single_use_link'
  get '/dashboard/shares(.:format)', to: 'scholars_archive/shares#index', as: 'dashboard_shares'
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'


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

  get '/mla/:id', to: 'scholars_archive/citations#mla', as: 'mla'
  get '/apa/:id', to: 'scholars_archive/citations#apa', as: 'apa'
  get '/chicago/:id', to: 'scholars_archive/citations#chicago', as: 'chicago'

  patch '/contentblock/update/:name', to: 'scholars_archive/content_blocks#update', as: 'update_content_blocks'

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable
    collection do
      delete 'clear'
    end
  end

  # CUSTOM ROUTES #1: Routes to deletion of all file sets
  namespace :hyrax, path: :concern do
    concerns_to_route.each do |curation_concern_name|
      namespaced_resources curation_concern_name, only: [] do
        member do
          delete :destroy_all_files
        end
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # ACCESSIBILITY REQUEST FORM ROUTE: Setup the routes for the accessibility form
  get 'accessibility_request', to: 'scholars_archive/accessibility_request_form#new', controller: 'scholars_archive/accessibility_request_form'
  post 'accessibility_request', to: 'scholars_archive/accessibility_request_form#create', as: :accessibility_request_form_index, controller: 'scholars_archive/accessibility_request_form'

  # bot detection challenge
  get "/challenge", to: "bot_detection#challenge", as: :bot_detect_challenge
  #post "/challenge", to: "bot_detection#verify_challenge"
end
