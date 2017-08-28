Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
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

  get '/xmlui/handle/:handle_id/:id', to: 'scholars_archive/handles#handle_show', as: 'handle_show'
  get '/xmlui/bitstream/handle/:handle_id/:id/:file', to: 'scholars_archive/handles#handle_download', as: 'handle_download'
  get '/404/file_not_found/:handle_id/:id/:file', to: 'scholars_archive/handles#handle_file_404', as: 'handle_file_404'
  get '/404/work_not_found', to: 'scholars_archive/handles#handle_work_404', as: 'handle_work_404'

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
