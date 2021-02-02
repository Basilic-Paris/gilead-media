Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users

  devise_scope :user do #as :user do
    get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
    patch 'users', to: 'devise/registrations#update', as: :user_registration
  end

  root to: 'pages#home'

  resources :documents, only: %i[index show] do
    patch :add_to_shared_list, on: :member
  end
  resources :folders, only: %i[index show] do
    patch :download, on: :member
    patch :add_to_shared_list, on: :member
  end

  # -------- ADMIN ROUTES ---------
  authenticate :user, ->(user) { user.admin } do
    namespace :admin do
      resources :users, only: %i[index create]
      resources :documents, only: %i[new create edit update] do
        patch :validate
      end
    end
  end
end
