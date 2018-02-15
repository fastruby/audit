Rails.application.routes.draw do

  get 'home/index'
  get '*path' => "home#index"

  root :to => "home#index"

  resources :gemfile, only: [:index, :new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
