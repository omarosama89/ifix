Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :auth do
    mount_devise_token_auth_for 'User', at: 'users', controllers: {
      registrations:      'auth/users/registrations',
      sessions:           'auth/users/sessions',
    }

    mount_devise_token_auth_for 'Provider', at: 'providers', controllers: {
      registrations:      'auth/providers/registrations',
      sessions:           'auth/providers/sessions',
    }
  end

  namespace :users do
    resources :services, only: [:index]

    resources :provider_services, only: [:index]

    resources :requests, only: [:create ]
  end
  namespace :providers do
    resources :requests, only: [] do
      member do
        put :accept
        put :process_request
        put :complete
      end
    end
  end
end
