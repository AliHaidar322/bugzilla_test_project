Rails.application.routes.draw do
  resources :projects, except: :show do
    resources :bugs
  end

  resources :bugs do
    member do
      get 'edit_status', to: 'bugs#edit_status', as: 'edit_status_bug'
      get 'assign', to: 'bugs#assign', as: 'assign_bug'
      patch 'update_status', to: 'bugs#update_status', as: 'update_status_bug'
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root to: "home#index"
  get 'bugs/:id/assign', to: 'bugs#assign', as: 'bugs_assign'
  get 'user_projects/:id/add_user', to: 'user_projects#add_user', as: 'user_projects_add_user'

  get 'user_projects/:id/add_to_project', to: 'user_projects#add_to_project', as: 'user_projects_add_to_project'
  get 'user_projects/:id/remove_from_project', to: 'user_projects#remove_from_project',
                                               as: 'user_projects_remove_from_project'
  get 'bugs/:id/edit_status', to: 'bugs#edit_status', as: 'bugs_edit_status'
  patch 'bugs/:id/update_status', to: 'bugs#update_status', as: 'bugs_update_status'
  get 'user_projects/:id/users', to: 'user_projects#users', as: 'user_projects_users'
  delete 'projects/:id', to: 'projects#destroy', as: 'project_destroy'
end
