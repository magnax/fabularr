# frozen_string_literal: true

Fabularr::Application.routes.draw do
  root to: 'static_pages#home'

  resources :characters, only: %i[new create] do
    get :talk
    get :set
    get :name
  end
  resources :char_names
  resources :events
  resources :locations do
    resources :location_resources, only: :new
  end
  resources :projects
  resources :sessions, only: %i[new create destroy]
  resources :users

  match '/register', to: 'users#new', via: 'get'
  match '/login', to: 'sessions#new', via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'
  match '/list', to: 'users#show', via: 'get'
end
