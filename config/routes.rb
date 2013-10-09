Logdives::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get 'users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  authenticate :user do
    resources :dives do
      resources :photos, :only => [:create, :destroy]
    end
    resources :users

    resources :user_uploads
    resources :buddies do
      collection do
        post 'request_confirmation'
      end
    end
    resources :buddy_confirmations
    resources :buddy_requests

    match "/clone_buddy/", :as => 'clone_buddy', :to => "buddy_confirmations#clone_buddy", :via => [:post]
    resource :log_starts

    match "/dives/new/:template", :to => "dives#new", :constraints => { :template => /.*/ }
    resource :preferences
    resources :profiles, :only => [:edit, :update]
  end



  match "/viewer/:id", :as => 'viewer', :to => "public_dives#show", :constraints => { :id => /.*/ }
  match "/latest", :as => 'latest', :to => "public_dives#index"

  resources :profiles, :only => [:show]
  match '/br/:id', :as => 'buddy_request_gateway', :to => "buddy_requests#gateway", :constraints => { :id => /.*/ }
  resources :dive_sites
  root :to => 'home#show'

end
