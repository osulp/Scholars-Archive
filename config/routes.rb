Rails.application.routes.draw do
  blacklight_for :catalog
  devise_for :users
  Hydra::BatchEdit.add_routes(self)

  get '/help/:page', :to => "help#page"
  get '/help', :to => "help#page", :page => "general"

  delete '/featured_researcher/:id/delete', :to => "content_blocks#destroy", :as => "delete_researcher"

  devise_scope :user do
    get "/users/sign_out", :to => "sessions#destroy"
  end

 
  # This must be the very last route in the file because it has a catch-all route for 404 errors.
  # This behavior seems to show up only in production mode.
  root to: 'homepage#index'
  mount HydraEditor::Engine => '/'
  mount Sufia::Engine => '/'
end
