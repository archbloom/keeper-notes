Rails.application.routes.draw do
  root 'home#index'
  get 'home/index'

  resources :notes

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/share', to: "notes#share"
end
