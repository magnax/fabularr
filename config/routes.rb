# frozen_string_literal: true

Fabularr::Application.routes.draw do
  root to: 'static_pages#home'

  get 'char_names/create'
  get 'characters/:id/set' => 'characters#set', as: :character_set
  get 'characters/:id/name' => 'characters#name', as: :character_name

  resources :users
  resources :sessions, only: %i[new create destroy]
  resources :characters, only: %i[new create]
  resources :char_names
  resources :events

  match '/register', to: 'users#new', via: 'get'
  match '/login', to: 'sessions#new', via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'
  match '/list', to: 'users#show', via: 'get'
end
