# frozen_string_literal: true

require 'sidekiq/web'

Fabularr::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' # http://localhost:3000/sidekiq

  root to: 'static_pages#home'

  scope '(:locale)', locale: /pl|en/ do
    resources :characters, only: %i[new create] do
      get :talk
      get :set
      get :name
    end
    resources :char_names
    resources :events
    resources :inventory_objects, only: %i[index create] do
      get :drop
    end
    resources :location_objects, only: [:create] do
      get :take
    end
    resources :locations do
      resources :location_resources, only: :new
    end
    resources :projects, only: :create do
      get :join
      get :leave
      get 'new/:type/:location_resource_id', to: 'projects#new', as: :new, on: :collection
    end
    resources :recipes, only: [:index]
    resources :sessions, only: %i[new create destroy]
    resources :users

    match '/register', to: 'users#new', via: 'get'
    match '/login', to: 'sessions#new', via: 'get'
    match '/logout', to: 'sessions#destroy', via: 'delete'
    match '/list', to: 'users#show', via: 'get'

    namespace :api do
      resources :events, only: :show
    end
  end
end
