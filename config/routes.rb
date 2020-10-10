require'sidekiq/web'
Rails.application.routes.draw do
  root 'home#index'
  get 'home/index'

  resources :notes do
    member do
      post :share
    end

    collection do
      post :share
      post :export
    end
  end
  authenticate :user, lambda { |u| u.present? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
