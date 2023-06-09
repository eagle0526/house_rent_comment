Rails.application.routes.draw do
  # devise_for :users, :controllers => { registrations: 'users/registrations' }
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', 
                                    registrations: 'users/registrations' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  namespace :admin do
    resources :users do
      member do
        delete '/images/:image_id' => 'users#destroy_image', as: :destroy_image
      end
    
      resources :houses, shallow: true do
        member do
          delete '/images/:image_id' => 'houses#destroy_image', as: :destroy_image
        end
      end
    end
  end

  resources :houses do
    member do
      resources :comments, shallow: true do
        member do
          patch :like
          patch :dislike
        end
      end

      # 房子按讚
      patch :like
      patch :dislike
      post :good
    end
    
  end


  # Defines the root path route ("/")
  # root "home#index"
  root "houses#index"
end
