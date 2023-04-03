Rails.application.routes.draw do
  # devise_for :users, :controllers => { registrations: 'users/registrations' }
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  namespace :admin do
    resources :users do
      resources :houses, shallow: true do
        member do
          delete '/images/:image_id' => 'houses#destroy_image', as: :destroy_image
        end
      end
    end
  end

  resources :houses


  # Defines the root path route ("/")
  root "home#index"
end
