Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users

  devise_scope :user do #as :user do
    get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
    put 'users', to: 'devise/registrations#update', as: :user_registration
  end

  root to: 'pages#home'

  # -------- ADMIN ROUTES ---------
  authenticate :user, ->(user) { user.admin } do
    namespace :admin do
      resources :users, only: %i[index create]
    end
  end
end
