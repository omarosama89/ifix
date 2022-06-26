Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :users do
    resources :registrations, only: [] do
      collection do
        post :sign_up
        post :validate
      end
    end
    resources :sessions, only: [] do
      collection do
        post :login
        post :validate
      end
    end

    resources :services, only: [:index]

    resources :provider_services, only: [:index]

    resources :requests, only: [:create ]
  end
  namespace :providers do
    resources :registrations, only: [] do
      collection do
        post :sign_up
        post :validate
      end
    end
    resources :sessions, only: [] do
      collection do
        post :login
        post :validate
      end
    end

    resources :requests, only: [] do
      member do
        put :accept
        put :process_request
        put :complete
      end
    end
  end
end
