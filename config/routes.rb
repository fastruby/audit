Rails.application.routes.draw do

  # Rails' built-in health check endpoint. Returns 200 when the app boots with
  # no exceptions, 500 otherwise. Responds with an HTML page (browsers/bots) or
  # a JSON body (Accept: application/json), so uptime monitors, load balancers,
  # and JSON clients are all covered by the same endpoint.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'home/index'
  get 'home/privacy'
  root :to => "home#index"


  resources :gemfiles, only: [:index, :new, :create, :show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
