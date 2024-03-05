Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users

  devise_scope :user do #as :user do
    get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
    patch 'users', to: 'devise/registrations#update', as: :user_registration
  end

  root to: 'pages#home'

  controller :pages do
    get :home
    get :tree_diagram
  end

  resources :documents, only: %i[index show] do
    # TO KEEP: initial version to add folders or documents to shared list directly
    # patch :add_to_shared_list, on: :member
    patch :download, on: :member
    member do
      resources :shared_documents, only: %i[new create]
    end
    member do
      get :add_to_shared_list_or_folder
      post :attach_to_new_shared_list
      post :attach_to_existing_shared_list
    end
  end

  resources :folders, only: %i[index show] do
    patch :download, on: :member
    # TO KEEP: initial version to add folders or documents to shared list directly
    # patch :add_to_shared_list, on: :member
    member do
      resources :shared_folders, only: %i[new create]
    end
    member do
      get :add_to_shared_list
      post :attach_to_new_shared_list
      post :attach_to_existing_shared_list
    end
  end
  resources :shared_lists, only: %i[index show] do
    patch :add_contacts, on: :member
    resources :folders, only: :show do
      patch :download, on: :member
    end
  end

  # -------- ADMIN ROUTES ---------
  authenticate :user, ->(user) { user.admin } do
    namespace :admin do
      resources :users, only: %i[index create destroy]
      resources :documents, only: %i[new create edit update destroy] do
        member do
          patch :unactive
          patch :active
          patch :archive
          post :attach_to_folder
        end
        resources :attachments, only: %i[destroy]
      end
      resources :folders, only: %i[destroy]
    end
  end

  # -------- PUBLIC ROUTES ---------
  namespace :public do
    root to: 'pages#home'
    resources :shared_lists, param: :code, only: %i[show] do
      resources :folders, only: %i[show]
      resources :documents, only: %i[show]
    end
    resources :shared_documents, param: :code, only: %i[show]
    resources :shared_folders, param: :code, only: %i[show] do
      resources :folders, only: %i[show]
      resources :documents, only: %i[show]
    end
  end
end
