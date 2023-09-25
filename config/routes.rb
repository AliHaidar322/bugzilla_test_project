Rails.application.routes.draw do
  resources :projects, except: :show do
    resources :bugs
  end

  resources :bugs
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root to: "home#index"
  get 'bugs/:id/assign', to: 'bugs#assign', as: 'bugs_assign'
  get 'userprojects/:id/add_user', to: 'userprojects#add_user', as: 'userprojects_add_user'

  get 'userprojects/:id/add_to_project', to: 'userprojects#add_to_project', as: 'userprojects_add_to_project'
  get 'userprojects/:id/remove_from_project', to: 'userprojects#remove_from_project',
                                              as: 'userprojects_remove_from_project'
  get 'bugs/:id/edit_status', to: 'bugs#edit_status', as: 'bugs_edit_status'
  patch 'bugs/:id/update_status', to: 'bugs#update_status', as: 'bugs_update_status'
  get 'userprojects/:id/users', to: 'userprojects#users', as: 'userprojects_users'
  get 'projects/:id/destroy', to: 'projects#destroy', as: 'projects_destroy'
end
