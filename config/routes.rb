Rails.application.routes.draw do
  resources :projects, except: :show do
    resources :bugs
  end

  resources :bugs do
    member do
      get '/bugs', to: 'bugs#index'
      get 'edit_status', to: 'bugs#edit_status', as: 'edit_status'
      patch 'assign', to: 'bugs#assign', as: 'assign'
      patch 'update_status', to: 'bugs#update_status', as: 'update_status'
    end
  end

  resources :user_projects, only: [] do
    member do
      get 'add_user'
      get 'add_to_project'
      get 'remove_from_project'
      get 'users'
    end
  end

  devise_for :users
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }
  root to: "home#index"
  delete 'projects/:id', to: 'projects#destroy', as: 'project_destroy'
end
