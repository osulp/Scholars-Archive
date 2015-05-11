##
# This overrides the routing for devise_cas_authenticatable so that it doesn't
# take over the destroy_session_path.
# 
# NOTE: This is a huge hack.

ActionDispatch::Routing::Mapper.class_eval do
  def devise_cas_authenticatable(mapping, controllers)
    sign_out_via = (Devise.respond_to?(:sign_out_via) && Devise.sign_out_via) || [:get, :post]

    # service endpoint for CAS server
    get "service", :to => "#{controllers[:cas_sessions]}#service", :as => "service"
    post "service", :to => "#{controllers[:cas_sessions]}#single_sign_out", :as => "single_sign_out"

    resource :session, :only => [], :controller => controllers[:cas_sessions], :path => "" do
      get :new, :path => mapping.path_names[:sign_in], :as => "new"
      get :unregistered
      post :create, :path => mapping.path_names[:sign_in]
    end
    resource :session, :only => [], :controller => "devise/sessions", :path => "" do
      match :destroy, :path => mapping.path_names[:sign_out], :as => "destroy", :via => sign_out_via
    end
  end
end
