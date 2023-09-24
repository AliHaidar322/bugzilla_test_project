Rails.application.routes.draw do
  get 'projects/index'
  get 'projects/new'
  get 'projects/create'
  get 'bugs/index'
  get 'bugs/new'
  get 'bugs/create'
  root 'home#index'
  # devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
