require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  resource :user, only: [] do
    collection do
      patch 'update_password'
      
      get 'finish_signup'
      patch 'finish_signup'
    end
  end


  # Internal Admin

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
